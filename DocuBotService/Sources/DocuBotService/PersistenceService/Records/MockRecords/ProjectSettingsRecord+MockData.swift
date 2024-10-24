//
//  ProjectSettingsRecord+MockData.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation

extension ProjectSettingsRecord {

    static func mocks() -> [ProjectSettingsRecord] {
        return [
            .mock(
                id: 1,
                projectID: 1,
                supportedFormats: ProjectSettingsRecord.DocumentationFormat.allCases,
                createdAt: .now,
                updatedAt: .now
            ),
            .mock(
                id: 2,
                projectID: 2,
                supportedFormats: [.md],
                createdAt: .now,
                updatedAt: .now
            ),
            .mock(
                id: 3,
                projectID: 3,
                supportedFormats: [.txt, .rtf, .md],
                createdAt: .now,
                updatedAt: .now
            )
        ]
    }

    static func mock(
        id: Int64 = 0,
        projectID: Int64 = 0,
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
    ) -> ProjectSettingsRecord {
        .init(
            id: id,
            project: projectID,
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
