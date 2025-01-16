//
//  GPTError.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import Foundation

/// Represents the errors that can occur in the GPT service.
///
/// The `GPTError` enum defines various error states related to model management
/// and response generation in the GPT service.
public enum GPTError: LocalizedError {

    /// Indicates that a specified model could not be found.
    ///
    /// - Parameter modelName: The name of the missing model.
    case noModel(modelName: String)

    /// Indicates a failure to create a language model due to decoding errors.
    case failedToCreateLLMDecodingError

    /// Indicates a failure to create a language model for a specific reason.
    ///
    /// - Parameter reason: A detailed description of the failure reason.
    case failedToCreateLLM(reason: String)

    /// Indicates that the language model has not been initialized.
    case llmNotInitialised
}

// MARK: - Public

public extension GPTError {

    /// A localized description of the error.
    ///
    /// This property returns a user-friendly, localized string describing the error,
    /// leveraging localization resources.
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

    /// Compares two `GPTError` instances for equality.
    ///
    /// The comparison considers associated values for cases like `.noModel` and `.failedToCreateLLM`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `GPTError` to compare.
    ///   - rhs: The right-hand side `GPTError` to compare.
    /// - Returns: A Boolean value indicating whether the two errors are equal.
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
