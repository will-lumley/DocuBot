//
//  ProjectSettingsRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation
import GRDB

/// A database record representing the settings for a project.
///
/// The `ProjectSettingsRecord` struct stores configuration details for a specific project,
/// including embedding models, similarity metrics, and various other settings used for
///  processing and generating content.
public struct ProjectSettingsRecord: Record {

    // MARK: - Types

    /// The supported languages for the project settings.
    public enum Language: String, Hashable, Codable, Sendable, CaseIterable {
        /// English language support.
        case english
    }

    /// The available embedding models for the project settings.
    public enum EmbeddingModel: String, Hashable, Codable, Sendable, CaseIterable {
        /// DistilBERT embedding model.
        case distilbert

        /// MiniLM-All embedding model.
        case miniLmAll

        /// MultiQA-MiniLM embedding model.
        case multiQaMiniLm
    }

    /// The similarity metrics available for the project settings.
    public enum SimilarityMetric: String, Hashable, Codable, Sendable, CaseIterable {
        /// Cosine similarity metric.
        case cosine

        /// Dot product similarity metric.
        case dotProduct

        /// Euclidean distance similarity metric.
        case euclideanDistance
    }

    /// The supported documentation formats for the project settings.
    public enum DocumentationFormat: Hashable, Codable, Sendable {

        /// Rich Text Format (.rtf).
        case rtf

        /// Plain text format (.txt).
        case txt

        /// Hypertext Markup Language (.html).
        case html

        /// Markdown (.md).
        case md

        /// Any other format specified by the user.
        case other(String)
    }

    // MARK: - Properties

    /// The unique identifier for the record.
    public var id: Int64?

    /// The identifier of the associated project.
    public let project: Int64

    /// The identifier of the associated embedding model.
    public let model: Int64

    /// The formats supported by the project.
    public let supportedFormats: [DocumentationFormat]

    /// The language associated with the project.
    public let language: Language

    /// The embedding model used for the project.
    public let embeddingModel: EmbeddingModel

    /// The similarity metric used for the project.
    public let similarityMetric: SimilarityMetric

    /// The random seed value for reproducibility.
    public let seed: Int

    /// The maximum number of results to return for a query.
    public let topK: Int

    /// The probability threshold for nucleus sampling.
    public let topP: Double

    /// The maximum context length for processing.
    public let contextLength: Int

    /// The temperature parameter for randomness in sampling.
    public let temperature: Double

    /// The batch size for processing.
    public let batchSize: Int

    /// The stop sequence for generated content.
    public let stopSequence: String?

    /// The maximum number of tokens for generated content.
    public let maxTokenCount: Int

    /// The system prompt used during content generation.
    public let systemPrompt: String

    /// A Boolean value indicating whether strict mode is enabled.
    public let strictMode: Bool

    /// The date and time when the record was created.
    public let createdAt: Date

    /// The date and time when the record was last updated.
    public let updatedAt: Date

    /// The name of the database table associated with this record.
    public static var databaseTableName: String {
        "project-settings"
    }

    // MARK: - GRDB Integration

    /// Updates the record with the unique identifier assigned upon insertion.
    ///
    /// - Parameter inserted: The result of the insertion operation.
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
