//
//  ProjectSettingsRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation
import GRDB

public struct ProjectSettingsRecord: Record {

    // MARK: - Types

    public enum Language: String, Hashable, Codable, Sendable, CaseIterable {
        case english
    }

    public enum EmbeddingModel: String, Hashable, Codable, Sendable, CaseIterable {
        case distilbert
        case miniLmAll
        case multiQaMiniLm
    }

    public enum SimilarityMetric: String, Hashable, Codable, Sendable, CaseIterable {
        case cosine
        case dotProduct
        case euclideanDistance
    }

    public enum DocumentationFormat: Hashable, Codable, CaseIterable, Sendable {
        public static var allCases: [ProjectSettingsRecord.DocumentationFormat] {
            [.rtf, .txt, .html, .md]
        }

        case rtf
        case txt
        case html
        case md
        case other(String)
    }

    // MARK: - Properties

    public var id: Int64?
    public let project: Int64
    public let model: Int64

    public let supportedFormats: [DocumentationFormat]
    public let language: Language

    public let embeddingModel: EmbeddingModel
    public let similarityMetric: SimilarityMetric

    public let seed: Int
    public let topK: Int
    public let topP: Double
    public let contextLength: Int
    public let temperature: Double
    public let batchSize: Int
    public let stopSequence: String?
    public let maxTokenCount: Int
    public let systemPrompt: String
    public let strictMode: Bool

    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "project-settings"
    }

    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
