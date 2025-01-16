//
//  LlamaService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import DocuBotModel
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
            fatalError()
        }

        // Create our LLM
        do {
            let configuration = Configuration(maxTokenCount: 1024 * 1024)
            self.llama = try SwiftLlama(modelPath: modelPath, modelConfiguration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - GPTService

    func respond(
        to query: String,
        from chat: DocuBotModel.Chat,
        from project: Project,
        onUpdate: @escaping OutputUpdated,
        onComplete: @escaping OutputComplete
    ) async throws {
        let prompt = Prompt(
            type: .llama3,
            systemPrompt: self.systemMessage,
            userMessage: query,
            history: []
        )

        var output = ""
        for try await value in await self.llama.start(for: prompt) {
            output += value
            Task {
                await onUpdate(value)
            }
        }

        Task {
            await onComplete(output)
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

// MARK: - DocuBotModel.Chat

extension DocuBotModel.Chat {

}
