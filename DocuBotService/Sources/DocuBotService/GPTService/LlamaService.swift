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
import Metal

/// An implementation of the `GPTService` protocol that integrates with `llama.cpp`.
///
/// The `LlamaService` uses `SwiftLlama` as an interface to manage language model
/// interactions, including priming the model and generating responses.
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
    var llama: LLM?

    /// Our LLM likes to prepend every bit of content with this, so we'll use
    /// this property to remove it before the data leaves this `Service`
    private let chatPrependage = "DocuBot:"

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
        self.llama = LLM(
            from: model.path,
            stopSequence: settings.stopSequence,
            seed: UInt32(settings.seed),
            topK: Int32(settings.topK),
            topP: Float(settings.topP),
            temp: Float(settings.temperature),
            maxTokenCount: Int32(settings.maxTokenCount)
        )
        // self.llama?.template = .chatML(settings.systemPrompt)
        self.llama?.template = .llama(settings.systemPrompt)
        // self.llama?.postprocess = { _ in }
    }

    /// Generates a response to a query, optionally providing real-time updates.
    ///
    /// This method processes the user's query and generates a response based
    /// on the primed model and settings.
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
        print("[DOCUBOT] Prompting: \(query)")

        var finalOutput = ""
        await llama.respond(to: query) { response in
            for await responseDelta in response {
                print("ResponseDelta: \(responseDelta)")
                finalOutput += responseDelta

                // Clean up our output
                if finalOutput.lowercased().contains(self.chatPrependage.lowercased()) {
                    finalOutput = finalOutput.removing(value: "  \(self.chatPrependage) ")
                    finalOutput = finalOutput.removing(value: "\(self.chatPrependage) ")
                }

                await onUpdate?(finalOutput)
            }
            print("[DOCUBOT] FinalOutput: \(finalOutput)")
            return finalOutput
        }

        print("[DOCUBOT] FinalOutput: \(finalOutput)")
        return finalOutput
    }

    /// Stops the response generation process.
    ///
    /// This method interrupts the ongoing interaction with the language model.
    public func stop() {
        self.llama?.stop()
    }

}
