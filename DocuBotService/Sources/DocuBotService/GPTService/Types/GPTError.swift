//
//  GPTError.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import Foundation

public enum GPTError: LocalizedError {
    case noModel(modelName: String)
    case failedToCreateLLMDecodingError
    case failedToCreateLLM(reason: String)
    case llmNotInitialised
}

// MARK: - CaseIterable

extension GPTError: CaseIterable {

    public static var allCases: [GPTError] {
        [
            .noModel(modelName: "Test Model"),
            .failedToCreateLLMDecodingError,
            .failedToCreateLLM(reason: "Test Reason"),
            .llmNotInitialised
        ]
    }

}

// MARK: - Public

public extension GPTError {

    var errorDescription: String? {
        switch self {
        case .noModel(let modelName):
            return L10n.Error.Gpt.noModel(modelName)
        case .failedToCreateLLMDecodingError:
            return L10n.Error.Gpt.failedToCreateLLMDecodingError
        case .failedToCreateLLM(let reason):
            return L10n.Error.Gpt.failedToCreateLLM(reason)
        case .llmNotInitialised:
            return L10n.Error.Gpt.llmNotInitialised
        }
    }

}

// MARK: - Equatable

extension GPTError: Equatable {

    public static func == (lhs: GPTError, rhs: GPTError) -> Bool {
        switch lhs {
        case .noModel(let lhsModelName):
            guard case .noModel(let rhsModelName) = rhs else {
                return false
            }
            return lhsModelName == rhsModelName

        case .failedToCreateLLM(let lhsReason):
            guard case .failedToCreateLLM(let rhsReason) = rhs else {
                return false
            }
            return lhsReason == rhsReason

        case .llmNotInitialised:
            guard case .llmNotInitialised = rhs else {
                return false
            }
            return true

        case .failedToCreateLLMDecodingError:
            guard case .failedToCreateLLMDecodingError = rhs else {
                return false
            }
            return true

        }
    }

}
