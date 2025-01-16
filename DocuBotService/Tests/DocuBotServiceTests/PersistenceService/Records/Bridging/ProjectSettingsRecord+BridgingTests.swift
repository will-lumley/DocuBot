//
//  ProjectSettingsRecord+Bridging+Tests.swift
//  DocuBotServiceTests
//
//  Created by William Lumley on 15/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
import GRDB
import Testing

struct ProjectSettingsBridgingTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Model to Record Bridging")
    func modelToRecordBridging() throws {
        // GIVEN we have sample data
        let id: Int64? = 42
        let projectID: Int64 = 1
        let modelID: Int64 = 2
        let supportedFormats: [ProjectSettings.DocumentationFormat] = [.html, .md]
        let language = ProjectSettings.Language.english
        let embeddingModel = ProjectSettings.EmbeddingModel.distilbert
        let similarityMetric = ProjectSettings.SimilarityMetric.cosine
        let seed = 12345
        let topK = 10
        let topP = 0.9
        let contextLength = 512
        let temperature = 0.7
        let batchSize = 16
        let stopSequence = "###"
        let maxTokenCount = 1024
        let systemPrompt = "Summarize the document."
        let strictMode = true
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Settings in the Model layer
        let model = ProjectSettings(
            id: id,
            projectID: projectID,
            modelID: modelID,
            supportedFormats: supportedFormats,
            language: language,
            embeddingModel: embeddingModel,
            similarityMetric: similarityMetric,
            seed: seed,
            topK: topK,
            topP: topP,
            contextLength: contextLength,
            temperature: temperature,
            batchSize: batchSize,
            stopSequence: stopSequence,
            maxTokenCount: maxTokenCount,
            systemPrompt: systemPrompt,
            strictMode: strictMode,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Settings to the Storage layer
        let record = ProjectSettingsRecord(model: model)

        // THEN there is no data loss
        #expect(record.id == model.id)
        #expect(record.project == model.projectID)
        #expect(record.model == model.modelID)
        #expect(record.supportedFormats.map(ProjectSettings.DocumentationFormat.init) == supportedFormats)
        #expect(record.language == ProjectSettingsRecord.Language(model: language))
        #expect(record.embeddingModel == ProjectSettingsRecord.EmbeddingModel(model: embeddingModel))
        #expect(record.similarityMetric == ProjectSettingsRecord.SimilarityMetric(model: similarityMetric))
        #expect(record.seed == model.seed)
        #expect(record.topK == model.topK)
        #expect(record.topP == model.topP)
        #expect(record.contextLength == model.contextLength)
        #expect(record.temperature == model.temperature)
        #expect(record.batchSize == model.batchSize)
        #expect(record.stopSequence == model.stopSequence)
        #expect(record.maxTokenCount == model.maxTokenCount)
        #expect(record.systemPrompt == model.systemPrompt)
        #expect(record.strictMode == model.strictMode)
        #expect(record.createdAt == model.createdAt)
        #expect(record.updatedAt == model.updatedAt)
    }

    @Test("Record to Model Bridging")
    func recordToModelBridging() throws {
        // GIVEN we have sample data
        let id: Int64? = 42
        let projectID: Int64 = 1
        let modelID: Int64 = 2
        let supportedFormats: [ProjectSettingsRecord.DocumentationFormat] = [.html, .md]
        let language = ProjectSettingsRecord.Language.english
        let embeddingModel = ProjectSettingsRecord.EmbeddingModel.distilbert
        let similarityMetric = ProjectSettingsRecord.SimilarityMetric.cosine
        let seed = 12345
        let topK = 10
        let topP = 0.9
        let contextLength = 512
        let temperature = 0.7
        let batchSize = 16
        let stopSequence = "###"
        let maxTokenCount = 1024
        let systemPrompt = "Summarize the document."
        let strictMode = true
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Settings in the Storage layer
        let record = ProjectSettingsRecord(
            id: id,
            project: projectID,
            model: modelID,
            supportedFormats: supportedFormats,
            language: language,
            embeddingModel: embeddingModel,
            similarityMetric: similarityMetric,
            seed: seed,
            topK: topK,
            topP: topP,
            contextLength: contextLength,
            temperature: temperature,
            batchSize: batchSize,
            stopSequence: stopSequence,
            maxTokenCount: maxTokenCount,
            systemPrompt: systemPrompt,
            strictMode: strictMode,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Settings to the Model layer
        let settings = ProjectSettings(record: record)

        // THEN there is not data loss
        #expect(settings.id == record.id)
        #expect(settings.projectID == record.project)
        #expect(settings.modelID == record.model)
        #expect(settings.supportedFormats.map(ProjectSettingsRecord.DocumentationFormat.init) == supportedFormats)
        #expect(settings.language == ProjectSettings.Language(record: language))
        #expect(settings.embeddingModel == ProjectSettings.EmbeddingModel(record: embeddingModel))
        #expect(settings.similarityMetric == ProjectSettings.SimilarityMetric(record: similarityMetric))
        #expect(settings.seed == record.seed)
        #expect(settings.topK == record.topK)
        #expect(settings.topP == record.topP)
        #expect(settings.contextLength == record.contextLength)
        #expect(settings.temperature == record.temperature)
        #expect(settings.batchSize == record.batchSize)
        #expect(settings.stopSequence == record.stopSequence)
        #expect(settings.maxTokenCount == record.maxTokenCount)
        #expect(settings.systemPrompt == record.systemPrompt)
        #expect(settings.strictMode == record.strictMode)
        #expect(settings.createdAt == record.createdAt)
        #expect(settings.updatedAt == record.updatedAt)
    }

    @Test(
        "Model to Record DocumentationFormat Bridging",
        arguments: ProjectSettings.DocumentationFormat.allCases + [.other("custom")]
    )
    func modelToRecordDocumentationFormatBridging(
        format: ProjectSettings.DocumentationFormat
    ) throws {
        // WHEN we convert our DocFormat from the Model layer to the Storage layer
        let recordFormat = ProjectSettingsRecord.DocumentationFormat(model: format)

        // THEN there is no data loss
        switch format {
        case .html:
            #expect(recordFormat == .html)
        case .md:
            #expect(recordFormat == .md)
        case .rtf:
            #expect(recordFormat == .rtf)
        case .txt:
            #expect(recordFormat == .txt)
        case .pdf:
            #expect(recordFormat == .pdf)
        case .other(let value):
            #expect(recordFormat == .other(value))
        }
    }

    @Test(
        "Record to Model DocumentationFormat Bridging",
        arguments: ProjectSettingsRecord.DocumentationFormat.allCases + [.other("custom")]
    )
    func recordToModelDocumentationFormatBridging(
        format: ProjectSettingsRecord.DocumentationFormat
    ) throws {
        // WHEN we convert our DocFormat from the Storage layer to the Model layer
        let modelFormat = ProjectSettings.DocumentationFormat(record: format)
        let recordFormat = ProjectSettingsRecord.DocumentationFormat(model: modelFormat)

        // THEN there is no data loss
        switch (format, recordFormat) {
        // Pass for predefined cases
        case (.html, .html),
             (.md, .md),
             (.rtf, .rtf),
             (.txt, .txt):
            break
        // Compare the associated value for `other`
        case let (.other(value), .other(recordValue)):
            #expect(value == recordValue)
        default:
            // Fail for mismatched cases
            Issue.record(
                "Mismatched bridging from model to record for DocumentationFormat."
            )
        }
    }

    @Test(
        "Model to Record Language Bridging",
        arguments: ProjectSettings.Language.allCases
    )
    func modelToRecordLanguageBridging(
        language: ProjectSettings.Language
    ) throws {
        // WHEN we convert our Language from the Model layer to the Storage layer
        let recordLanguage = ProjectSettingsRecord.Language(model: language)

        // THEN there is no data loss
        switch language {
        case .english:
            #expect(recordLanguage == .english)
        }
    }

    @Test(
        "Record to Model Language Bridging",
        arguments: ProjectSettingsRecord.Language.allCases
    )
    func recordToModelLanguageBridging(language: ProjectSettingsRecord.Language) throws {
        // WHEN we convert our Language from the Storage layer to the Model layer
        let modelLanguage = ProjectSettings.Language(record: language)

        // THEN there is no data loss
        switch language {
        case .english:
            #expect(modelLanguage == .english)
        }
    }

    @Test(
        "Model to Record EmbeddingModel Bridging",
        arguments: ProjectSettings.EmbeddingModel.allCases
    )
    func modelToRecordEmbeddingModelBridging(model: ProjectSettings.EmbeddingModel) throws {
        // WHEN we convert our Embedding from the Model layer to the Storage layer
        let recordModel = ProjectSettingsRecord.EmbeddingModel(model: model)

        // THEN there is no data loss
        #expect(recordModel.rawValue == model.rawValue)
    }

    @Test(
        "Record to Model EmbeddingModel Bridging",
        arguments: ProjectSettingsRecord.EmbeddingModel.allCases
    )
    func recordToModelEmbeddingModelBridging(record: ProjectSettingsRecord.EmbeddingModel) throws {
        // WHEN we convert our Embedding from the Storage layer to the Model layer
        let model = ProjectSettings.EmbeddingModel(record: record)

        // THEN there is no data loss
        #expect(model.rawValue == record.rawValue)
    }

    @Test(
        "Model to Record SimilarityMetric Bridging",
        arguments: ProjectSettings.SimilarityMetric.allCases
    )
    func modelToRecordSimilarityMetricBridging(metric: ProjectSettings.SimilarityMetric) throws {
        // WHEN we convert our metric from the Model layer to the Storage layer
        let recordMetric = ProjectSettingsRecord.SimilarityMetric(model: metric)

        // THEN there is no data loss
        #expect(recordMetric.rawValue == metric.rawValue)
    }

    @Test(
        "Record to Model SimilarityMetric Bridging",
        arguments: ProjectSettingsRecord.SimilarityMetric.allCases
    )
    func recordToModelSimilarityMetricBridging(record: ProjectSettingsRecord.SimilarityMetric) throws {
        // WHEN we convert our metric from the Storage layer to the Model layer
        let model = ProjectSettings.SimilarityMetric(record: record)

        // Assert the conversion matches
        #expect(model.rawValue == record.rawValue)
    }

}

// MARK: - ProjectSettingsRecord.DocumentationFormat.CaseIterable

extension ProjectSettingsRecord.DocumentationFormat: CaseIterable {

    /// Provides a list of all possible `ProjectSettingsRecord.DocumentationFormat` cases.
    ///
    /// This is primarily useful for testing and enumerating all error types.
    public static var allCases: [ProjectSettingsRecord.DocumentationFormat] {
        [
            .html, .md, .txt, .rtf
        ]
    }
}
