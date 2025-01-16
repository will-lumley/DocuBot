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

    func prime(
        with model: LLMModel,
        with settings: ProjectSettings
    ) throws(GPTError) {
        // Create our LLM
        do {
            // Create the configuration from the settings
            let configuration = Configuration(settings: settings)

            // Create our LLM
            self.llama = try SwiftLlama(
                modelPath: model.path,
                modelConfiguration: configuration
            )
        } catch {
            throw GPTError.failedToCreateLLM(
                reason: error.localizedDescription
            )
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

            // If the current value is a newline, increment the newline count
            if formattedValue == "\n" {
                newlineCount += 1
            } else {
                // Reset newline count if it's not a newline
                newlineCount = 0
            }

            // If we've encountered 3 consecutive newlines, break the loop
            if newlineCount == 3 {
                // swiftlint:disable:next direct_print
                print("[DOCUBOT] [INFO] Breaking due to newline overload.")
                break
            }

            output += formattedValue

            Task {
                await onUpdate?(formattedValue)
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
