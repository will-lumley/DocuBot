//
//  Document.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import CryptoKit
import Foundation
import SimilaritySearchKit

public struct Document: Hashable, Codable {

    // MARK: - Types

    public struct Embedding: Hashable, Codable {
        public let chunk: String
        public let embedding: [Float]

        public init(chunk: String, embedding: [Float]) {
            self.chunk = chunk
            self.embedding = embedding
        }
    }

    public enum ChecksumGenerationError: Error {
        case failedStringToDataConversion
    }

    // MARK: - Properties

    public let id: Int64?
    public let url: URL
    public let fileFormat: ProjectSettings.DocumentationFormat
    public let content: String
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
        projectID: Int64,
        embeddings: [Embedding]?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.url = url
        self.fileFormat = fileFormat
        self.content = content
        self.projectID = projectID
        self.embeddings = embeddings
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Document {

    var llmReference: String {
        L10n.Document.LlmReference.template(self.url.path(), self.content)
    }

}

// MARK: - [Document]

public extension Array where Element == Document {

    func generateChecksum() throws -> String {
        // Concatenate all document contents into a single string
        let combinedContent = self.map(\.content).joined(separator: "\n")

        // Convert the combined content to data
        guard let contentData = combinedContent.data(using: .utf8) else {
            throw Document.ChecksumGenerationError.failedStringToDataConversion
        }

        // Generate SHA-256 hash
        let hash = SHA256.hash(data: contentData)

        // Convert hash to hex string
        return hash.map { String(format: "%02x", $0) }.joined()
    }


}
