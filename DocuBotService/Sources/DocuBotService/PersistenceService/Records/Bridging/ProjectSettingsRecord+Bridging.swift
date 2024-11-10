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
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettingsRecord.Language {

    init(model: ProjectSettings.Language) {
        switch model {
        case .english: self = .english
        }
    }

}

public extension ProjectSettingsRecord.EmbeddingModel {

    init(model: ProjectSettings.EmbeddingModel) {
        switch model {
        case .distilbert: self = .distilbert
        case .miniLmAll: self = .miniLmAll
        case .multiQaMiniLm: self = .multiQaMiniLm
        }
    }

}

public extension ProjectSettingsRecord.SimilarityMetric {

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
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettings.Language {

    init(record: ProjectSettingsRecord.Language) {
        switch record {
        case .english: self = .english
        }
    }

}

public extension ProjectSettings.EmbeddingModel {

    init(record: ProjectSettingsRecord.EmbeddingModel) {
        switch record {
        case .distilbert: self = .distilbert
        case .miniLmAll: self = .miniLmAll
        case .multiQaMiniLm: self = .multiQaMiniLm
        }
    }

}

public extension ProjectSettings.SimilarityMetric {

    init(record: ProjectSettingsRecord.SimilarityMetric) {
        switch record {
        case .cosine: self = .cosine
        case .dotProduct: self = .dotProduct
        case .euclideanDistance: self = .euclideanDistance
        }
    }

}
