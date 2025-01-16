//
//  LlamaService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import DocuBotModel
import DocuBotToolbox
import Foundation

/// An implementation of the `GPTService` protocol that integrates with `llama.cpp`.
///
/// The `LlamaService` uses `SwiftLlama` as an interface to manage language model interactions, including
/// priming the model and generating responses.
final class LlamaService: GPTService {

    // MARK: - Service

    /// The unique key identifying the GPT service.
    ///
    /// This key is used to register the `LlamaService` within a service container.
    static var key: ServiceKey {
        .gpt
    }

    // MARK: - Properties

    /// The interface to `llama.cpp`, used for managing the language model.
    var llama: SwiftLlama?

    // MARK: - Lifecycle

    /// Creates a new instance of `LlamaService`.
    ///
    /// This initializer sets up the service but does not configure the `llama` interface until priming.
    init() {
        // Intentionally left blank.
    }

    // MARK: - GPTService

    /// Primes the service with a language model and project settings.
    ///
    /// This method initializes the `llama` interface using the provided model and settings.
    ///
    /// - Parameters:
    ///   - model: The `LLMModel` to use for priming.
    ///   - settings: The `ProjectSettings` that define model configuration parameters.
    /// - Throws: A `GPTError` if the model initialization fails.
    public func prime(
        with model: LLMModel,
        with settings: ProjectSettings
    ) throws(GPTError) {
        do {
            // Create the configuration from the settings
            let configuration = Configuration(settings: settings)

            // Initialize the `llama` interface
            self.llama = try SwiftLlama(
                modelPath: model.path,
                modelConfiguration: configuration
            )
        } catch {
            if let llamaError = error as? SwiftLlamaError {
                switch llamaError {
                case .decodeError:
                    throw GPTError.failedToCreateLLMDecodingError
                case .others(let reason):
                    throw GPTError.failedToCreateLLM(reason: reason)
                }
            } else {
                throw GPTError.failedToCreateLLM(reason: error.localizedDescription)
            }
        }
    }

    /// Generates a response to a query, optionally providing real-time updates.
    ///
    /// This method processes the user's query and generates a response based on the primed model and settings.
    /// It also prevents excessive newline spamming by monitoring consecutive newline characters.
    ///
    /// - Parameters:
    ///   - query: The user's input query.
    ///   - systemMessage: A system-level prompt providing context or instructions for the response.
    ///   - onUpdate: An optional closure that provides incremental updates to the response text.
    /// - Returns: The full response string after generation is complete.
    /// - Throws: A `GPTError` if the model is not initialized or if response generation fails.
    public func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String {
        guard let llama else {
            throw GPTError.llmNotInitialised
        }

        let prompt = Prompt(
            type: .llama3,
            systemPrompt: systemMessage,
            userMessage: query,
            history: []
        )

        var newlineCount = 0
        var output = ""

        for try await value in await llama.start(for: prompt) {
            let formattedValue = value.replacingOccurrences(of: "\0", with: "")

            if formattedValue == "\n" {
                newlineCount += 1
            } else {
                newlineCount = 0
            }

            if newlineCount == 3 {
                // swiftlint:disable:next direct_print
                print("[DOCUBOT] [INFO] Breaking due to newline overload.")
                break
            }

            output += formattedValue
            await onUpdate?(formattedValue)
        }

        return output.trimmingTrailingNewlines()
    }

    /// Stops the response generation process.
    ///
    /// This method interrupts the ongoing interaction with the language model.
    public func stop() {
        self.llama?.stop()
    }

}

private extension Configuration {

    /// Initializes a `Configuration` instance from `ProjectSettings`.
    ///
    /// This extension simplifies the creation of a `Configuration` object using values from project settings.
    ///
    /// - Parameter settings: The `ProjectSettings` to use for configuration.
    init(settings: ProjectSettings) {
        self.init(
            seed: settings.seed,
            topK: settings.topK,
            topP: Float(settings.topP),
            nCTX: settings.contextLength,
            temperature: Float(settings.temperature),
            batchSize: settings.batchSize,
            stopSequence: settings.stopSequence,
            maxTokenCount: settings.maxTokenCount
        )
    }

}
