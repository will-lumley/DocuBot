//
//  DocumentBuilder.swift
//  DocuBotModel
//
//  Created by William Lumley on 3/10/2024.
//

import DocuBotToolbox
import Foundation
import SimilaritySearchKit
import SimilaritySearchKitDistilbert

public class DocumentParser {

    // MARK: - Types

    public enum DocumentError: LocalizedError {
        case noBookmarkData
        case bookmarkIsStale
    }

    public struct DocumentSyncReponse {
        public let checksum: String
        public let documents: [Document]
    }

    public typealias OnSyncUpdate = (_ progress: Int, _ total: Int) -> Void

    // MARK: - Properties

    private let project: Project
    private let settings: ProjectSettings
    private let onSyncUpdate: OnSyncUpdate

    private let tokenSplitter = CharacterSplitter(withSeparator: " ")

    private var formats: [ProjectSettings.DocumentationFormat] {
        self.settings.supportedFormats
    }

    // MARK: - Lifecycle

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

    func createAndParse() async throws -> DocumentSyncReponse {
        // Pull out our URL Bookmark Data so we can access this data securely
        let urlBookmarkData = self.project.urlBookmarkData
        guard urlBookmarkData.isEmpty == false else {
            throw DocumentError.noBookmarkData
        }

        // Create a temporary secure URL with read access to the users document data
        var isStale = false
        let directory = try URL(
            resolvingBookmarkData: urlBookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )

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

        // Generate our checksum so we can tell for later if we need to re-sync
        let checksum = try documents.generateChecksum()
        return .init(checksum: checksum, documents: documents)
    }

    func checkProjectIsDirty() async throws -> Bool {
        // Pull out our URL Bookmark Data so we can access this data securely
        let urlBookmarkData = self.project.urlBookmarkData
        guard urlBookmarkData.isEmpty == false else {
            throw DocumentError.noBookmarkData
        }

        // Create a temporary secure URL with read access to the users document data
        var isStale = false
        let directory = try URL(
            resolvingBookmarkData: urlBookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )

        // Open up our access, and make sure our data isn't stale
        guard isStale == false, directory.startAccessingSecurityScopedResource() else {
            throw DocumentError.bookmarkIsStale
        }

        // Pull out our files from disk
        let files = try await self.extractFilesFromDisk(from: directory)

        // Create documents out of them
        let documents = try await self.createDocuments(from: files)

        // Compare the collection of documents' checksum against the current checksum
        let newChecksum = try documents.generateChecksum()
        guard let oldChecksum = self.project.documentationChecksum else {
            return false
        }

        return newChecksum != oldChecksum
    }

}

// MARK: - Private

private extension DocumentParser {

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

    func createDocuments(from files: [URL]) async throws -> [Document] {
        // This is going to hold the documents that represent the files
        // in our directory.
        var documents = [Document]()

        // Enumerate over each file in the directory
        for url in files {
            // Extract the documents content as a string file
            guard let content = try? String(contentsOf: url, encoding: .utf8) else {
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

            // If we're not supposed to do a full resync
            if project.needsFullResync == false {
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

    func existingDocument(with url: URL) -> Document? {
        return self.project.documents?.first(where: {
            $0.url == url
        })
    }

    func chunks(from content: String) -> [String] {
        let chunkSize = 100
        let chunkOverlap = 20

        let (chunks, _) = self.tokenSplitter.split(
            text: content,
            chunkSize: chunkSize,
            overlapSize: chunkOverlap
        )

        // print("Chunks: \(chunks)")
        // print("Tokens: \(tokens)")

        return chunks
    }

    /// Retrieves the documentation file format from the provided URL based on its file extension.
    ///
    /// - Parameter url: The URL of the file to extract the extension from.
    /// - Returns: The documentation format based on the file extension, or `nil` if the extension is invalid.
    ///
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
    ///
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
    ///
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

    public var errorDescription: String? {
        switch self {
        case .noBookmarkData:
            return L10n.Error.Document.noBookmarkData
        case .bookmarkIsStale:
            return L10n.Error.Document.bookmarkIsStale
        }
    }

}
