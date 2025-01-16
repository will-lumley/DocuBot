//
//  GPTService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import DocuBotModel
import Foundation

public enum GPTError: LocalizedError {
    case noModel(modelName: String)
    case failedToCreateLLM(reason: String)
    case llmNotInitialised

    public var errorDescription: String? {
        switch self {
        case .noModel(let modelName):
            return L10n.Error.Gpt.noModel(modelName)
        case .failedToCreateLLM(let reason):
            return L10n.Error.Gpt.failedToCreateLLM(reason)
        case .llmNotInitialised:
            return L10n.Error.Gpt.llmNotInitialised
        }
    }
}

public protocol GPTService: Service {

    typealias OutputUpdated = @MainActor (_ delta: String) -> Void

    func prime(with settings: ProjectSettings) throws(GPTError)

    func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String
}
