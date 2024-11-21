//
//  Document.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import DocuBotToolbox
import Foundation
import SimilaritySearchKit

public struct Document: Hashable, Codable, Sendable {

    // MARK: - Types

    public enum DocumentError: LocalizedError {
        case missingID
    }

    public enum ChecksumGenerationError: LocalizedError {
        case failedConversion
    }

    public struct Embedding: Hashable, Codable, Sendable, Equatable {
        public let chunk: String
        public let embedding: [Float]

        public init(chunk: String, embedding: [Float]) {
            self.chunk = chunk
            self.embedding = embedding
        }
    }

    // MARK: - Properties

    public let id: Int64?
    public let url: URL
    public let fileFormat: ProjectSettings.DocumentationFormat
    public let content: String
    public let checksum: String
    public let projectID: Int64
    public var embeddings: [Embedding]?
    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Lifecycle

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

    var documentTitle: String {
        self.url.lastPathComponent
    }

    var llmReference: String {
        L10n.Document.LlmReference.template(self.url.path(), self.content)
    }

}

// MARK: - Equatable

extension Document: Equatable {

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

    var errorDescription: String? {
        switch self {
        case .missingID:
            return L10n.Error.Document.missingID
        }
    }

}

// MARK: - ChecksumGenerationError

public extension Document.ChecksumGenerationError {

    var errorDescription: String? {
        switch self {
        case .failedConversion:
            return L10n.Error.Document.checksumGeneration
        }
    }

}
