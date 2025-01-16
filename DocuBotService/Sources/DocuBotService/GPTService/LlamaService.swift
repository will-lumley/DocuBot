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
import SwiftLlama

class LlamaService: GPTService {

    // MARK: - Service

    static var key: ServiceKey {
        .gpt
    }

    // MARK: - Properties

    /// Our interface to llama.cpp
    private var llama: SwiftLlama?

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - GPTService

    func prime(with settings: ProjectSettings) throws(GPTError) {
        let modelName = "llama-2-7b-chat.Q5_K_S"
        guard let modelPath = Bundle.main.path(
            forResource: modelName,
            ofType: "gguf"
        ) else {
            throw GPTError.noModel(modelName: modelName)
        }

        // Create our LLM
        do {
            // Create the configuration from the settings
            let configuration = Configuration(settings: settings)

            // Create our LLM
            self.llama = try SwiftLlama(
                modelPath: modelPath,
                modelConfiguration: configuration
            )
        } catch {
            throw GPTError.failedToCreateLLM(reason: error.localizedDescription)
        }

    }

    func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String {
        guard let llama else {
            throw GPTError.llmNotInitialised
        }

        // Create our prompt
        let prompt = Prompt(
            type: .llama3,
            systemPrompt: systemMessage,
            userMessage: query,
            history: []
        )

        // We'll keep an eye on how many newlines there are
        // so we can stop the AI from spamming \n
        var newlineCount = 0

        // This is where we'll store the output
        var output = ""

        // Iterate over every value we have
        for try await value in await llama.start(for: prompt) {
            // Strip the null terminators from the string
            let formattedValue = value.replacingOccurrences(of: "\0", with: "")

            // If our last output was a newline, and this is also a newline, let's bail out
            if newlineCount == 2 {
                // break
            }

            // Append the value to the output
            output += formattedValue

            // Send out the update to the caller
            Task {
                await onUpdate?(formattedValue)
            }

            // If we're a newline, update the newline count
            if formattedValue == "\n" {
                newlineCount += 1
            }
        }

        return output.trimmingTrailingNewlines()
    }

}

private extension Configuration {

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
