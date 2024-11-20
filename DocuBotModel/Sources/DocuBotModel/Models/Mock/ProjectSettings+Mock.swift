//
//  ProjectSettings+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension ProjectSettings {

    static func mock(
        id: Int64? = nil,
        projectID: Int64 = 0,
        modelID: Int64 = 0,
        supportedFormats: [DocumentationFormat] = DocumentationFormat.allCases,
        language: Language = .english,
        embeddingModel: EmbeddingModel = .distilbert,
        similarityMetric: SimilarityMetric = .cosine,
        seed: Int = 1024,
        topK: Int = 40,
        topP: Double = 0.2,
        contextLength: Int = 100,
        temperature: Double = 0.2,
        batchSize: Int = 1024,
        stopSequence: String? = nil,
        maxTokenCount: Int = 1024,
        systemPrompt: String = "You are a good bot",
        strictMode: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> ProjectSettings {
        .init(
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
    }

}
