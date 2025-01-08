//
//  LLMModel+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension LLMModel {

    /// Creates a mock instance of `LLMModel` for testing purposes.
    ///
    /// This method generates an `LLMModel` instance with predefined or customizable default values,
    /// useful for unit testing or prototyping.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the model (optional; default is `nil`).
    ///   - name: The name of the model (default is `"Cool Model Name"`).
    ///   - path: The file path where the model is stored (default is `"/path/to/model"`).
    ///   - size: The size of the model in bytes (default is `4000`).
    ///   - createdAt: The timestamp indicating when the model was created (default is the current date).
    ///   - updatedAt: The timestamp indicating when the model was last updated (default is the current date).
    ///
    /// - Returns: A `LLMModel` instance populated with the specified or default values.
    ///
    /// # Example
    /// ```swift
    /// let mockModel = LLMModel.mock(
    ///     id: 123,
    ///     name: "Test Model",
    ///     path: "/models/test_model",
    ///     size: 1024,
    ///     createdAt: Date(timeIntervalSince1970: 0),
    ///     updatedAt: Date()
    /// )
    /// ```
    static func mock(
        id: Int64? = nil,
        name: String = "Cool Model Name",
        path: String = "/path/to/model",
        size: Int64 = 4000,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) -> LLMModel {
        .init(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
