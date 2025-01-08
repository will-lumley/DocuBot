//
//  ProjectSettings+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension ProjectSettings {

    /// Creates a mock instance of `ProjectSettings` for testing purposes.
    ///
    /// This method allows you to generate a `ProjectSettings` instance with predefined
    /// or customizable default values. It is particularly useful for unit testing or prototyping.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the settings (default is `nil`).
    ///   - projectID: The identifier of the project the settings belong to (default is `0`).
    ///   - modelID: The identifier of the model associated with the settings (default is `0`).
    ///   - supportedFormats: The supported documentation
    ///   formats (default is `[.rtf, .txt, .html, .md]`).
    ///   - language: The language setting (default is `.english`).
    ///   - embeddingModel: The embedding model to use (default is `.distilbert`).
    ///   - similarityMetric: The similarity metric to use (default is `.cosine`).
    ///   - seed: The seed value for random operations (default is `1024`).
    ///   - topK: The top-K parameter for the model (default is `40`).
    ///   - topP: The top-P parameter for the model (default is `0.2`).
    ///   - contextLength: The context length for the model (default is `100`).
    ///   - temperature: The temperature parameter for the model (default is `0.2`).
    ///   - batchSize: The batch size for processing (default is `1024`).
    ///   - stopSequence: An optional stop sequence for text generation (default is `nil`).
    ///   - maxTokenCount: The maximum token count (default is `1024`).
    ///   - systemPrompt: The system prompt for the bot (default is `"You are a good bot"`).
    ///   - strictMode: A Boolean value indicating whether strict mode is enabled (default is `false`).
    ///   - createdAt: The creation timestamp (default is the current date).
    ///   - updatedAt: The last updated timestamp (default is the current date).
    ///
    /// - Returns: A `ProjectSettings` instance populated with the specified or default values.
    ///
    /// # Example
    /// ```swift
    /// let mockSettings = ProjectSettings.mock(
    ///     projectID: 1,
    ///     modelID: 42,
    ///     supportedFormats: [.md, .html],
    ///     strictMode: true
    /// )
    /// ```
    static func mock(
        id: Int64? = nil,
        projectID: Int64 = 0,
        modelID: Int64 = 0,
        supportedFormats: [DocumentationFormat] = [.rtf, .txt, .html, .md],
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
