//
//  DocumentBuilder.swift
//  DocuBotModel
//
//  Created by William Lumley on 3/10/2024.
//

import DocuBotToolbox
import Foundation
import PDFKit
import SimilaritySearchKit
import SimilaritySearchKitDistilbert

/// A class responsible for parsing and managing project documents.
///
/// The `DocumentParser` class provides functionality to securely access, parse, and index
/// documents within a project. It also supports validation and checksum-based synchronization
/// to track changes in the document set.
public class DocumentParser {

    // MARK: - Types

    /// Errors that may occur during document parsing.
    public enum DocumentError: LocalizedError {
        /// Indicates that no bookmark data is available for the project.
        case noBookmarkData

        /// Indicates that the bookmark data is stale and cannot be used.
        case bookmarkIsStale
    }

    /// Errors that may occur during content extraction
    public enum ContentExtractionError: LocalizedError {
        /// Indicates that we could not get access to this file
        case failedToReadFile

        /// Indicates that we managed to get the file, but couldn't read its contents
        case failedToReadContent
    }

    /// A structure representing the result of a document synchronization operation.
    public struct DocumentSyncReponse: Sendable {
        /// The checksum of the synchronized documents.
        public let checksum: String

        /// The array of synchronized documents.
        public let documents: [Document]
    }

    /// A typealias for a closure that updates progress during synchronization.
    ///
    /// - Parameters:
    ///   - progress: The current progress count.
    ///   - total: The total number of steps to complete synchronization.
    public typealias OnSyncUpdate = (_ progress: Int, _ total: Int) -> Void

    // MARK: - Properties

    /// The project whose documents are being parsed.
    private let project: Project

    /// The settings for the project, defining how documents are processed.
    private let settings: ProjectSettings

    /// A closure that is called to update synchronization progress.
    private let onSyncUpdate: OnSyncUpdate

    /// A token splitter used for dividing content into chunks.
    private let tokenSplitter = CharacterSplitter(withSeparator: " ")

    /// The list of formats supported by the project settings.
    private var formats: [ProjectSettings.DocumentationFormat] {
        self.settings.supportedFormats
    }

    // MARK: - Lifecycle

    /// Creates a new `DocumentParser` instance.
    ///
    /// - Parameters:
    ///   - project: The project whose documents are to be parsed.
    ///   - settings: The settings for parsing and indexing the documents.
    ///   - onSyncUpdate: A closure to handle synchronization progress updates.
    public init(
        project: Project,
        settings: ProjectSettings,
        onSyncUpdate: @escaping OnSyncUpdate
    ) {
        self.project = project
        self.settings = settings
        self.onSyncUpdate = onSyncUpdate
    }

}

// MARK: - Public

public extension DocumentParser {

    /// Parses and synchronizes documents for the project.
    ///
    /// This method resolves the project's bookmark data to access the document directory,
    /// extracts files, creates document representations, and indexes them.
    ///
    /// - Returns: A `DocumentSyncReponse` containing the checksum and parsed documents.
    /// - Throws: `DocumentError` if bookmark data is unavailable or stale.
    func createAndParse() async throws -> DocumentSyncReponse {
        // Pull out our URL Bookmark Data so we can access this data securely
        let urlBookmarkData = self.project.urlBookmarkData
        guard urlBookmarkData.isEmpty == false else {
            throw DocumentError.noBookmarkData
        }

        // Create a temporary secure URL with read access to the users document data
        var isStale = false
        guard let directory = try? URL(
            resolvingBookmarkData: urlBookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            throw DocumentError.bookmarkIsStale
        }

        // Open up our access, and make sure our data isn't stale
        guard isStale == false, directory.startAccessingSecurityScopedResource() else {
            throw DocumentError.bookmarkIsStale
        }

        // Pull out the files from disk and store them in memory
        let files = try await self.extractFilesFromDisk(from: directory)

        // Turn each file into a Document
        var documents = try await self.createDocuments(from: files)

        // Index each document
        documents = try await self.index(documents: documents)

        // Close our access, we're done here
        directory.stopAccessingSecurityScopedResource()

        // Generate our checksum so we can tell for
        // later if we need to re-sync
        let checksum = try documents.generateChecksum()
        return .init(checksum: checksum, documents: documents)
    }

    /// Checks if the project's documents are "dirty," indicating changes since the last sync.
    ///
    /// This method calculates the checksum of the current documents and compares it
    /// against the previously stored checksum.
    ///
    /// - Returns: `true` if the documents are dirty, otherwise `false`.
    /// - Throws: `DocumentError` if bookmark data is unavailable or stale.
    func checkProjectIsDirty() async throws -> Bool {
        // Pull out our URL Bookmark Data so we can access this data securely
        let urlBookmarkData = self.project.urlBookmarkData
        guard urlBookmarkData.isEmpty == false else {
            throw DocumentError.noBookmarkData
        }

        // Create a temporary secure URL with read access to
        // the users document data.
        var isStale = false
        guard let directory = try? URL(
            resolvingBookmarkData: urlBookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            throw DocumentError.bookmarkIsStale
        }

        // Open up our access, and make sure our data isn't stale
        guard isStale == false, directory.startAccessingSecurityScopedResource() else {
            throw DocumentError.bookmarkIsStale
        }

        // Pull out our files from disk
        let files = try await self.extractFilesFromDisk(from: directory)

        // Create documents out of them
        let documents = try await self.createDocuments(from: files)

        // Compare the collection of documents' checksum against
        // the current checksum.
        let newChecksum = try documents.generateChecksum()
        guard let oldChecksum = self.project.documentationChecksum else {
            return false
        }

        return newChecksum != oldChecksum
    }

}

// MARK: - Private

internal extension DocumentParser {

    /// Extracts files from the specified directory.
    ///
    /// This method enumerates all files in the directory and filters them based on valid
    /// documentation formats.
    ///
    /// - Parameter directory: The directory to extract files from.
    /// - Returns: An array of valid file URLs.
    /// - Throws: Errors related to file access or enumeration.
    func extractFilesFromDisk(from directory: URL) async throws -> [URL] {
        var files = [URL]()

        // Create an enumerator to iterate over the files in our directory
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil
        )

        // Enumerate over each file in the directory
        while let url = enumerator?.nextObject() as? URL {
            // Make sure this file is a documentation type
            guard self.validDocumentation(at: url) else {
                continue
            }

            files.append(url)
        }

        return files
    }

    /// Creates `Document` instances from an array of file URLs.
    ///
    /// - Parameter files: The array of file URLs.
    /// - Returns: An array of `Document` objects.
    /// - Throws: `Document.ChecksumGenerationError` if checksum generation fails.
    func createDocuments(from files: [URL]) async throws -> [Document] {
        // This is going to hold the documents that represent the files
        // in our directory.
        var documents = [Document]()

        // Enumerate over each file in the directory
        for url in files {
            // Extract the documents content as a string file
            guard let content = try? self.extractContent(from: url) else {
                continue
            }

            guard let checksum = content.checksum else {
                throw Document.ChecksumGenerationError.failedConversion
            }

            // Create the in-memory document representation of this file
            let document = Document(
                url: url,
                fileFormat: self.fileExtension(from: url),
                content: content,
                checksum: checksum,
                projectID: settings.projectID,
                embeddings: nil,
                createdAt: .now,
                updatedAt: .now
            )
            documents.append(document)
        }

        return documents
    }

    /// This function will take in a file URL and extract the content out of the file
    /// and return it as a `String`.
    ///
    /// - Parameter url: The file that we're trying to extract content out of
    /// - Returns: The contents of the file
    func extractContent(
        from url: URL
    ) throws(ContentExtractionError) -> String? {
        let fileExtension = self.fileExtension(from: url)

        switch fileExtension {
        case .txt, .md, .other:
            return try self.loadPlainText(from: url)
        case .rtf:
            return try self.loadDocumentText(from: url, with: .rtf)
        case .html:
            return try self.loadDocumentText(from: url, with: .html)
        case .pdf:
            return try self.loadPdf(from: url)
        case .word:
            return try self.loadDocumentText(from: url, with: .officeOpenXML)
        }
    }

    /// Indexes the given documents by calculating embeddings.
    ///
    /// This method splits document content into chunks and calculates embeddings
    /// using the project's embedding model and similarity metric.
    ///
    /// - Parameter documents: The documents to index.
    /// - Returns: An array of indexed `Document` objects.
    /// - Throws: Errors during embedding calculation.
    func index(documents: [Document]) async throws -> [Document] {
        // For tracking our progress
        var current = 0
        let total = documents.count

        // Create our indexer with the model and metric as set by the user
        let similarityIndex = await SimilarityIndex(
            model: self.settings.embeddingModel.embeddingsProtocol,
            metric: self.settings.similarityMetric.metricProtocol
        )

        // Where we'll store the documents that we index
        var indexed = [Document]()

        // Iterate over each document and index it
        for document in documents {
            // Everytime we finish an iteration, update our progress
            defer {
                // Update our progress
                current += 1

                // Update our called on the sync progress
                self.onSyncUpdate(current, total)
            }

            // If we have an alert, we will definitely do a re-sync
            if project.alertStatus == .none {
                // If we have an existing document from this project
                if let existingDocument = self.existingDocument(with: document.url) {
                    // If this existing document has existing indexing data
                    if existingDocument.embeddings != nil {
                        // If this existing document is the same as the new one
                        if existingDocument.checksum == document.checksum {
                            // Then we don't need to re-index, let's skip this one
                            indexed.append(existingDocument)

                            let title = existingDocument.documentTitle
                            // swiftlint:disable:next direct_print
                            print("[DOCUBOT] [INFO] Skipping indexing for \(title)")

                            continue
                        }
                    }
                }
            }

            // Split the content into chunks
            let chunks = self.chunks(from: document.content)

            // Calculate the embedded value for each chunk
            let embedded = await chunks
                .asyncMap { chunk in
                    let value = await similarityIndex.getEmbedding(for: chunk)
                    return Document.Embedding(chunk: chunk, embedding: value)
                }

            // Copy our content over, and add our indexing data
            let indexedDocument = Document(
                url: document.url,
                fileFormat: document.fileFormat,
                content: document.content,
                checksum: document.checksum,
                projectID: document.projectID,
                embeddings: embedded,
                createdAt: document.createdAt,
                updatedAt: document.updatedAt
            )
            indexed.append(indexedDocument)
        }

        return indexed
    }

    /// Finds an existing document in the project with the specified URL.
    ///
    /// This method searches the project's loaded documents to determine if a document
    /// with the given URL already exists.
    ///
    /// - Parameter url: The URL of the document to search for.
    /// - Returns: The `Document` object with the matching URL, or `nil` if no such document exists.
    func existingDocument(with url: URL) -> Document? {
        return self.project.documents?.first(where: {
            $0.url == url
        })
    }

    /// Splits the given content into overlapping chunks for processing.
    ///
    /// This method divides the input text into chunks of a specified size with an overlap
    /// to ensure continuity across chunk boundaries. It uses a token splitter to perform
    /// the chunking process.
    ///
    /// - Parameter content: The input text to be split into chunks.
    /// - Returns: An array of string chunks derived from the input text.
    func chunks(from content: String) -> [String] {
        let chunkSize = 100
        let chunkOverlap = 20

        let (chunks, _) = self.tokenSplitter.split(
            text: content,
            chunkSize: chunkSize,
            overlapSize: chunkOverlap
        )

        return chunks
    }

    /// Retrieves the documentation file format from the file URL's extension.
    ///
    /// - Parameter url: The URL of the file.
    /// - Returns: The `DocumentationFormat` of the file.
    func fileExtension(from url: URL) -> ProjectSettings.DocumentationFormat {
        let rawFileExtension = url.pathExtension
        return ProjectSettings.DocumentationFormat(rawValue: rawFileExtension)
    }

    /// Verifies whether the file at the provided URL has a valid documentation format.
    ///
    /// This method checks if the file extension matches one of the allowed documentation
    /// formats specified in the user's settings.
    ///
    /// - Parameter url: The URL of the file to validate.
    /// - Returns: A Boolean value indicating whether the file is in a valid documentation format.
    func validDocumentation(at url: URL) -> Bool {
        let fileExtension = self.fileExtension(from: url)

        // If this file has the extension that user indicated that they're
        // okay with us touching.
        guard self.formats.contains(fileExtension) else {
            return false
        }

        return true
    }

    /// Counts the number of valid documentation files in the directory at the specified URL.
    ///
    /// This method recursively enumerates through the directory and checks each file to see
    /// if it matches one of the allowed documentation formats specified in the user's settings.
    ///
    /// - Parameter url: The URL of the directory to search through.
    /// - Returns: The number of valid documentation files found in the directory.
    func documentationCount(at url: URL) -> Int {
        let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: nil
        )

        var count = 0
        while let url = enumerator?.nextObject() as? URL {
            // Make sure this file is a documentation type
            guard self.validDocumentation(at: url) else {
                continue
            }

            count += 1
        }

        return count
    }

}

// MARK: - DocumentParser.DocumentError

extension DocumentParser.DocumentError {

    /// A localized description of the document parser error.
    public var errorDescription: String? {
        switch self {
        case .noBookmarkData:
            return L10n.Error.Document.noBookmarkData
        case .bookmarkIsStale:
            return L10n.Error.Document.bookmarkIsStale
        }
    }

}

// MARK: - DocumentParser.Content

extension DocumentParser.ContentExtractionError {

    /// A localized description of the document parser error.
    public var errorDescription: String? {
        switch self {
        case .failedToReadFile:
            return L10n.Error.ContentExtraction.failedToReadFile
        case .failedToReadContent:
            return L10n.Error.ContentExtraction.failedToReadContent
        }
    }

}
