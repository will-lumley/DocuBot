//
//  Model.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation

/// A model representing a machine learning model within the system.
///
/// The `LLMModel` struct encapsulates metadata and properties related to a machine learning model,
/// including its name, path, size, and creation and update timestamps.
public struct LLMModel: Hashable, Codable, Sendable, Identifiable {

    // MARK: - Types

    /// Errors that may occur while working with an `LLMModel`.
    public enum ModelError: LocalizedError {
        /// Indicates that the model is missing an `id`.
        case missingID
    }

    /// Errors that may occur while fetching an `LLMModel`.
    public enum ModelFetchError: LocalizedError {
        /// Indicates that the model's binary file is missing.
        case binaryMissing
    }

    // MARK: - Properties

    /// The unique identifier for this model. May be `nil` if the model has not been inserted into the database.
    public let id: Int64?

    /// The user-defined name for the model.
    public let name: String

    /// The file path of the model's binary file.
    public var path: String

    /// The size of the binary file in bytes.
    public var size: Int64

    /// The creation date of the model.
    public let createdAt: Date

    /// The last updated date of the model.
    public let updatedAt: Date

    // MARK: - Lifecycle

    /// Creates a new instance of `LLMModel`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the model (optional).
    ///   - name: The user-defined name for the model.
    ///   - path: The file path of the model's binary file.
    ///   - size: The size of the binary file in bytes.
    ///   - createdAt: The creation timestamp of the model.
    ///   - updatedAt: The last updated timestamp of the model.
    public init(
        id: Int64? = nil,
        name: String,
        path: String,
        size: Int64,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.size = size
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension LLMModel {

    /// The subdirectory where models are stored.
    ///
    /// - Returns: A string representing the subdirectory name.
    static var subdirectory: String {
        "Models"
    }

}

// MARK: - Equatable

extension LLMModel: Equatable {

    /// Compares two `LLMModel` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `LLMModel` to compare.
    ///   - rhs: The right-hand side `LLMModel` to compare.
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    public static func == (lhs: LLMModel, rhs: LLMModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.path == rhs.path &&
            lhs.name == rhs.name &&
            lhs.size == rhs.size &&
            lhs.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            lhs.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

    /// Compares two `LLMModel` instances for equality, ignoring their `id` values.
    ///
    /// - Parameter rhs: The `LLMModel` to compare against.
    /// - Returns: `true` if all properties except `id` are equal, otherwise `false`.
    public func isEqualToIgnoringID(
        _ rhs: LLMModel
    ) -> Bool {
        return
            self.path == rhs.path &&
            self.name == rhs.name &&
            self.size == rhs.size &&
            self.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            self.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

}

// MARK: - ModelError

public extension LLMModel.ModelError {

    /// A localized description of the model error.
    var errorDescription: String? {
        switch self {
        case .missingID:
            return L10n.Error.Model.missingID
        }
    }

}

// MARK: - ModelFetchError

public extension LLMModel.ModelFetchError {

    /// A localized description of the model fetch error.
    var errorDescription: String? {
        switch self {
        case .binaryMissing:
            return L10n.Error.Model.binaryMissing
        }
    }

}
