//
//  ProjectSettingsRecord+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension ProjectSettingsRecord {

    /// Initializes a `ProjectSettingsRecord` from a `ProjectSettings` model.
    ///
    /// This initializer converts a `ProjectSettings` instance into its corresponding `ProjectSettingsRecord`
    /// representation for database storage. It maps all relevant properties, including supported formats, language,
    /// embedding model, similarity metric, and other metadata.
    ///
    /// - Parameter model: The `ProjectSettings` model to convert.
    init(model: ProjectSettings) {
        let language = ProjectSettingsRecord.Language(model: model.language)
        let formats = model.supportedFormats.map {
            ProjectSettingsRecord.DocumentationFormat(model: $0)
        }
        let embeddingModel = ProjectSettingsRecord.EmbeddingModel(
            model: model.embeddingModel
        )
        let similarityMetric = ProjectSettingsRecord.SimilarityMetric(
            model: model.similarityMetric
        )

        self.init(
            id: model.id,
            project: model.projectID,
            model: model.modelID,
            supportedFormats: formats,
            language: language,
            embeddingModel: embeddingModel,
            similarityMetric: similarityMetric,
            seed: model.seed,
            topK: model.topK,
            topP: model.topP,
            contextLength: model.contextLength,
            temperature: model.temperature,
            batchSize: model.batchSize,
            stopSequence: model.stopSequence,
            maxTokenCount: model.maxTokenCount,
            systemPrompt: model.systemPrompt,
            strictMode: model.strictMode,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

public extension ProjectSettingsRecord.DocumentationFormat {

    /// Initializes a `ProjectSettingsRecord.DocumentationFormat` from
    /// a `ProjectSettings.DocumentationFormat`.
    ///
    /// This initializer converts the documentation format from the model into a database-compatible representation.
    ///
    /// - Parameter model: The `ProjectSettings.DocumentationFormat` to convert.
    init(model: ProjectSettings.DocumentationFormat) {
        switch model {
        case .html:
            self = .html
        case .md:
            self = .md
        case .rtf:
            self = .rtf
        case .txt:
            self = .txt
        case .pdf:
            self = .pdf
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettingsRecord.Language {

    /// Initializes a `ProjectSettingsRecord.Language` from a `ProjectSettings.Language`.
    ///
    /// - Parameter model: The `ProjectSettings.Language` to convert.
    init(model: ProjectSettings.Language) {
        switch model {
        case .english: self = .english
        }
    }

}

public extension ProjectSettingsRecord.EmbeddingModel {

    /// Initializes a `ProjectSettingsRecord.EmbeddingModel`
    /// from a `ProjectSettings.EmbeddingModel`.
    ///
    /// - Parameter model: The `ProjectSettings.EmbeddingModel` to convert.
    init(model: ProjectSettings.EmbeddingModel) {
        switch model {
        case .distilbert: self = .distilbert
        case .miniLmAll: self = .miniLmAll
        case .multiQaMiniLm: self = .multiQaMiniLm
        }
    }

}

public extension ProjectSettingsRecord.SimilarityMetric {

    /// Initializes a `ProjectSettingsRecord.SimilarityMetric`
    /// from a `ProjectSettings.SimilarityMetric`.
    ///
    /// - Parameter model: The `ProjectSettings.SimilarityMetric` to convert.
    init(model: ProjectSettings.SimilarityMetric) {
        switch model {
        case .cosine: self = .cosine
        case .dotProduct: self = .dotProduct
        case .euclideanDistance: self = .euclideanDistance
        }
    }

}

// MARK: - Model

public extension ProjectSettings {

    /// Initializes a `ProjectSettings` model from a `ProjectSettingsRecord`.
    ///
    /// This initializer converts a `ProjectSettingsRecord` from the database into its
    /// corresponding `ProjectSettings` model,
    /// including all properties such as supported formats, language, embedding model,
    /// similarity metric, and other metadata.
    ///
    /// - Parameter record: The `ProjectSettingsRecord` to convert.
    init(record: ProjectSettingsRecord) {
        let formats = record.supportedFormats.map(ProjectSettings.DocumentationFormat.init)
        let language = ProjectSettings.Language(record: record.language)

        let embeddingModel = ProjectSettings.EmbeddingModel(
            record: record.embeddingModel
        )
        let similarityMetric = ProjectSettings.SimilarityMetric(
            record: record.similarityMetric
        )

        self.init(
            id: record.id,
            projectID: record.project,
            modelID: record.model,
            supportedFormats: formats,
            language: language,
            embeddingModel: embeddingModel,
            similarityMetric: similarityMetric,
            seed: record.seed,
            topK: record.topK,
            topP: record.topP,
            contextLength: record.contextLength,
            temperature: record.temperature,
            batchSize: record.batchSize,
            stopSequence: record.stopSequence,
            maxTokenCount: record.maxTokenCount,
            systemPrompt: record.systemPrompt,
            strictMode: record.strictMode,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}

public extension ProjectSettings.DocumentationFormat {

    /// Initializes a `ProjectSettings.DocumentationFormat`
    /// from a `ProjectSettingsRecord.DocumentationFormat`.
    ///
    /// - Parameter record: The `ProjectSettingsRecord.DocumentationFormat` to convert.
    init(record: ProjectSettingsRecord.DocumentationFormat) {
        switch record {
        case .html:
            self = .html
        case .md:
            self = .md
        case .rtf:
            self = .rtf
        case .txt:
            self = .txt
        case .pdf:
            self = .pdf
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettings.Language {

    /// Initializes a `ProjectSettings.Language` from a `ProjectSettingsRecord.Language`.
    ///
    /// - Parameter record: The `ProjectSettingsRecord.Language` to convert.
    init(record: ProjectSettingsRecord.Language) {
        switch record {
        case .english: self = .english
        }
    }

}

public extension ProjectSettings.EmbeddingModel {

    /// Initializes a `ProjectSettings.EmbeddingModel`
    /// from a `ProjectSettingsRecord.EmbeddingModel`.
    ///
    /// - Parameter record: The `ProjectSettingsRecord.EmbeddingModel` to convert.
    init(record: ProjectSettingsRecord.EmbeddingModel) {
        switch record {
        case .distilbert: self = .distilbert
        case .miniLmAll: self = .miniLmAll
        case .multiQaMiniLm: self = .multiQaMiniLm
        }
    }

}

public extension ProjectSettings.SimilarityMetric {

    /// Initializes a `ProjectSettings.SimilarityMetric`
    /// from a `ProjectSettingsRecord.SimilarityMetric`.
    ///
    /// - Parameter record: The `ProjectSettingsRecord.SimilarityMetric` to convert.
    init(record: ProjectSettingsRecord.SimilarityMetric) {
        switch record {
        case .cosine: self = .cosine
        case .dotProduct: self = .dotProduct
        case .euclideanDistance: self = .euclideanDistance
        }
    }

}
