//
//  Model.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation

public struct Model: Hashable, Codable, Sendable {

    // MARK: - Types

    public enum ModelError: LocalizedError {
        case missingID
    }

    public enum ModelFetchError: LocalizedError {
        case binaryMissing
    }

    // MARK: - Properties

    /// The unique property for this project. Is `nil` if the project hasn't been
    /// inserted into the DB yet
    public let id: Int64?

    /// The name the user gave to this model
    public let name: String

    /// The file path of the project
    public var path: String

    /// The size of the binary we're referencing
    public var size: Int64

    /// When this model was created
    public let createdAt: Date

    /// When this model was last updated
    public let updatedAt: Date

    // MARK: - Lifecycle

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
