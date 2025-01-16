//
//  Document.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import DocuBotToolbox
import Foundation
import SimilaritySearchKit

/// Represents a single document within a project.
///
/// The `Document` struct encapsulates metadata, content, and optional embeddings
/// for a document that belongs to a project.
public struct Document: Hashable, Codable, Sendable {

    // MARK: - Types

    /// Errors that may occur while working with a `Document`.
    public enum DocumentError: LocalizedError {
        /// Indicates that the document is missing an `id`.
        case missingID
    }

    /// Errors that may occur during checksum generation for a document.
    public enum ChecksumGenerationError: LocalizedError {
        /// Indicates that checksum generation failed due to a conversion error.
        case failedConversion
    }

    /// Represents an embedding for a chunk of text within a document.
    public struct Embedding: Hashable, Codable, Sendable, Equatable {
        /// The text chunk associated with this embedding.
        public let chunk: String

        /// The embedding vector for the text chunk.
        public let embedding: [Float]

        /// Creates a new `Embedding` instance.
        ///
        /// - Parameters:
        ///   - chunk: The text chunk.
        ///   - embedding: The embedding vector.
        public init(chunk: String, embedding: [Float]) {
            self.chunk = chunk
            self.embedding = embedding
        }
    }

    // MARK: - Properties

    /// The unique identifier for this document. May be `nil` if the document has not been inserted into the database.
    public let id: Int64?

    /// The file URL of the document.
    public let url: URL

    /// The file format of the document, based on its extension.
    public let fileFormat: ProjectSettings.DocumentationFormat

    /// The content of the document as a string.
    public let content: String

    /// A checksum representing the document's content for change detection.
    public let checksum: String

    /// The identifier of the project this document belongs to.
    public let projectID: Int64

    /// Optional embeddings for the document's content.
    public var embeddings: [Embedding]?

    /// The creation timestamp of the document.
    public let createdAt: Date

    /// The last updated timestamp of the document.
    public let updatedAt: Date

    // MARK: - Lifecycle

    /// Creates a new instance of `Document`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the document (optional).
    ///   - url: The file URL of the document.
    ///   - fileFormat: The file format of the document.
    ///   - content: The content of the document.
    ///   - checksum: The checksum representing the document's content.
    ///   - projectID: The identifier of the project the document belongs to.
    ///   - embeddings: Optional embeddings for the document's content.
    ///   - createdAt: The creation timestamp of the document.
    ///   - updatedAt: The last updated timestamp of the document.
    public init(
        id: Int64? = nil,
        url: URL,
        fileFormat: ProjectSettings.DocumentationFormat,
        content: String,
        checksum: String,
        projectID: Int64,
        embeddings: [Embedding]?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.url = url
        self.fileFormat = fileFormat
        self.content = content
        self.checksum = checksum
        self.projectID = projectID
        self.embeddings = embeddings
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Document {

    /// The title of the document, derived from its file name.
    ///
    /// - Returns: The last path component of the document's URL.
    var documentTitle: String {
        self.url.lastPathComponent
    }

    /// A reference string used for LLM integration, combining the document's path and content.
    ///
    /// - Returns: A formatted string with the document's path and content.
    var llmReference: String {
        L10n.Document.LlmReference.template(self.url.path(), self.content)
    }

}

// MARK: - Equatable

extension Document: Equatable {

    /// Compares two `Document` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Document` to compare.
    ///   - rhs: The right-hand side `Document` to compare.
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    public static func == (lhs: Document, rhs: Document) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.url == rhs.url &&
            lhs.fileFormat == rhs.fileFormat &&
            lhs.content == rhs.content &&
            lhs.checksum == rhs.checksum &&
            lhs.projectID == rhs.projectID &&
            lhs.embeddings == rhs.embeddings &&
            lhs.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            lhs.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

    /// Compares two `Document` instances for equality, ignoring their `id` values.
    ///
    /// - Parameter rhs: The `Document` to compare against.
    /// - Returns: `true` if all properties except `id` are equal, otherwise `false`.
    public func isEqualToIgnoringID(
        _ rhs: Document
    ) -> Bool {
        return
            self.url == rhs.url &&
            self.fileFormat == rhs.fileFormat &&
            self.content == rhs.content &&
            self.checksum == rhs.checksum &&
            self.projectID == rhs.projectID &&
            self.embeddings == rhs.embeddings &&
            self.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            self.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

}

// MARK: - [Document]

public extension Array where Element == Document {

    /// Generates a checksum for the array of documents.
    ///
    /// This method concatenates the content of all documents into a single string and calculates
    /// its checksum.
    ///
    /// - Returns: A checksum string representing the combined content of all documents.
    /// - Throws: `Document.ChecksumGenerationError.failedConversion`
    /// if checksum generation fails.
    func generateChecksum() throws -> String {
        // Concatenate all document contents into a single string
        let combinedContent = self.map(\.content).joined(separator: "\n")

        // Grab their checksum
        guard let checksum = combinedContent.checksum else {
            throw Document.ChecksumGenerationError.failedConversion
        }

        return checksum
    }

}

// MARK: - DocumentError

public extension Document.DocumentError {

    /// A localized description of the document error.
    var errorDescription: String? {
        switch self {
        case .missingID:
            return L10n.Error.Document.missingID
        }
    }

}

// MARK: - ChecksumGenerationError

public extension Document.ChecksumGenerationError {

    /// A localized description of the checksum generation error.
    var errorDescription: String? {
        switch self {
        case .failedConversion:
            return L10n.Error.Document.checksumGeneration
        }
    }

}
