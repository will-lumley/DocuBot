//
//  LLMModelRecord+Bridging.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotModel

// MARK: - Record

public extension LLMModelRecord {

    /// Initializes an `LLMModelRecord` from an `LLMModel`.
    ///
    /// This initializer converts an `LLMModel` instance into its corresponding
    /// `LLMModelRecord` representation.
    /// It maps all properties, such as the model's name, path, size, and metadata, for database storage.
    ///
    /// - Parameter model: The `LLMModel` to convert into a `LLMModelRecord`.
    init(model: LLMModel) {
        self.init(
            id: model.id,
            name: model.name,
            path: model.path,
            size: model.size,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

// MARK: - Model

public extension LLMModel {

    /// Initializes an `LLMModel` from an `LLMModelRecord`.
    ///
    /// This initializer converts an `LLMModelRecord` instance from the database into its
    /// corresponding `LLMModel` model.
    /// It maps all properties, such as the model's name, path, size, and metadata, for use in application logic.
    ///
    /// - Parameter record: The `LLMModelRecord` to convert into an `LLMModel`.
    init(record: LLMModelRecord) {
        self.init(
            id: record.id,
            name: record.name,
            path: record.path,
            size: record.size,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}
