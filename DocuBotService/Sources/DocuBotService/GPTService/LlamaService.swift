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
    private let llama: SwiftLlama

    // MARK: - Lifecycle

    init() {
        guard let modelPath = Bundle.main.path(
            forResource: "llama-2-7b-chat.Q5_K_S",
            ofType: "gguf"
        ) else {
            fatalError("Failed to find model")
        }

        // Create our LLM
        do {
            let configuration = Configuration()
            self.llama = try SwiftLlama(modelPath: modelPath, modelConfiguration: configuration)
        } catch {
            fatalError("Failed to create LLM. \(error)")
        }
    }

    // MARK: - GPTService

    func respond(
        to query: String,
        from project: Project,
        onUpdate: @escaping OutputUpdated,
        onComplete: @escaping OutputComplete
    ) async throws {
        // Create our prompt
        let prompt = Prompt(
            type: .llama3,
            systemPrompt: self.systemMessage,
            userMessage: query,
            history: []
        )

        /*
         chat.messages.map { message in
             switch message.author {
             case .docubot:
                 return .init(user: "", bot: message.content)
             case .user:
                 return .init(user: message.content, bot: "")
             }
         }
         */

        // We'll keep an eye on how many newlines there are
        // so we can stop the AI from spamming \n
        var newlineCount = 0

        // This is where we'll store the output
        var output = ""

        // Iterate over every value we have
        for try await value in await self.llama.start(for: prompt) {
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
                await onUpdate(formattedValue)
            }

            // If we're a newline, update the newline count
            if formattedValue == "\n" {
                newlineCount += 1
            }
        }

        // We've left the for loop, so we're done here
        Task {
            await onComplete(output.trimmingTrailingNewlines())
        }
    }

}

// MARK: - Private

private extension LlamaService {

    var systemMessage: String {
        """
        You are a helpful assistant named DocuBot.
        DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries.
        You have been trained on a directory that contains the relevant documentation.
        You are expected to answer the user's questions to their code base.
        You should only respond to user messages and not repeat or continue your own previous responses.
        Do not reply to this message.
        """
    }

}
