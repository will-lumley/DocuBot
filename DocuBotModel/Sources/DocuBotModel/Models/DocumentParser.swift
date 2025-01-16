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

    public enum DocumentError: Error {
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
        // Pull out the files from disk and store them in memory
        let documents = try await self.extractFilesFromDisk()

        // Generate our checksum so we can tell for later
        // if we need to re-sync
        let checksum = try documents.generateChecksum()
        return .init(checksum: checksum, documents: documents)
    }

}

// MARK: - Private

private extension DocumentParser {

    /// Extracts documentation files from a secured directory on disk.
    ///
    /// This method securely accesses a directory using a previously stored bookmark, enumerates over the files
    /// in that directory, and returns an array of `Document` objects representing the documentation files found.
    /// It ensures that only valid documentation files are processed and handles stale bookmarks.
    ///
    /// - Throws:
    ///   - `DocumentError.noBookmarkData` if the bookmark data for accessing the directory is missing.
    ///   - `DocumentError.bookmarkIsStale` if the bookmark data is stale or the security scope could not be accessed.
    /// - Returns: An array of `Document` objects extracted from the directory.
    ///
    func extractFilesFromDisk() async throws -> [Document] {
        // This is going to hold the documents that represent the files
        // in our directory.
        var documents = [Document]()

        // Pull out our URL Bookmark Data so we can access this data securely
        let urlBookmarkData = self.project.urlBookmarkData
        guard let urlBookmarkData else {
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

        // Create an enumerator to iterate over the files in our directory
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil
        )

        let totalFileCount = self.documentationCount(at: directory)
        var currentFile = 0

        let similarityIndex = await SimilarityIndex(
            model: self.settings.embeddingModel.embeddingsProtocol,
            metric: self.settings.similarityMetric.metricProtocol
        )

        // Enumerate over each file in the directory
        while let url = enumerator?.nextObject() as? URL {

            // Make sure this file is a documentation type
            guard self.validDocumentation(at: url) else {
                continue
            }

            currentFile += 1

            // Update our called on the sync progress
            self.onSyncUpdate(currentFile, totalFileCount)

            // Extract the documents content as a string file
            guard let content = try? String(String(contentsOf: url, encoding: .utf8)) else {
                continue
            }

            // Split the content into chunks
            let chunks = self.chunks(from: content)

            // Calculate the embedded value for each chunk
            let embedded = await chunks
                .asyncMap { chunk in
                    let value = await similarityIndex.getEmbedding(for: chunk)
                    return Document.Embedding(chunk: chunk, embedding: value)
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
                embeddings: embedded,
                createdAt: .now,
                updatedAt: .now
            )
            documents.append(document)
        }

        // Close our access, we're done here
        directory.stopAccessingSecurityScopedResource()

        return documents
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
        /*
        return enumerator?.count(where: { nextObject in
            guard let url = enumerator?.nextObject() as? URL else {
                return false
            }

            return self.validDocumentation(at: url)
        }) ?? 0
        */
    }

}
