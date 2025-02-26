//
//  SwiftLlamaService.swift
//  DocuBotService
//
//  Created by William Lumley on 26/2/2025.
//

import Combine
import DocuBotModel
import DocuBotToolbox
import Foundation

/// An implementation of the `GPTService` protocol that integrates with `llama.cpp`.
///
/// The `LlamaService` uses `SwiftLlama` as an interface to manage language model
/// interactions, including priming the model and generating responses.
final class SwiftLlamaService: GPTService {

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

    /// The `ProjectSettings` that this GPTService was primed with.
    var settings: ProjectSettings?

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
        // Ensure we have a model file at our path
        if FileManager.default.fileExists(atPath: model.path) == false {
            throw .noModel(modelName: model.name)
        }

        do {
            // Create the configuration from the settings
            let configuration = Configuration(settings: settings)

            // Initialize the `llama` interface
            self.llama = try SwiftLlama(
                modelPath: model.path,
                modelConfiguration: configuration
            )
            self.settings = settings
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
    ///   - onUpdate: An optional closure that provides incremental updates to the response text.
    /// - Returns: The full response string after generation is complete.
    /// - Throws: A `GPTError` if the model is not initialized or if response generation fails.
    public func respond(
        to query: String,
        onUpdate: OutputUpdated?
    ) async throws -> String {
        guard
            let llama,
            let settings
        else {
            throw GPTError.llmNotInitialised
        }

        let prompt = SwiftLlama.Prompt(
            type: .llama3,
            systemPrompt: settings.systemPrompt,
            userMessage: query,
            history: []
        )

        var newlineCount = 0
        var finalOutput = ""

        for try await value in await llama.start(for: prompt) {
            let formattedValue = value.replacingOccurrences(of: "\0", with: "")

            finalOutput += formattedValue
            await onUpdate?(finalOutput)

            /*

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
             */
        }
        self.llama?.clear()

        return finalOutput
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
            temperature: Float(settings.temperature),
            stopSequence: settings.stopSequence,
            maxTokenCount: settings.maxTokenCount
        )
    }

}
