//
//  LLMModelRecord.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation
import GRDB

/// A database record representing a machine learning model.
///
/// The `LLMModelRecord` struct defines the properties and behaviors of a machine learning
/// model stored in the database.
public struct LLMModelRecord: Record {

    // MARK: - Properties

    /// The unique identifier for the model.
    ///
    /// This value is assigned by the database upon insertion.
    public var id: Int64?

    /// The name of the machine learning model.
    public let name: String

    /// The file path where the model is stored.
    public let path: String

    /// The size of the model file in bytes.
    public let size: Int64

    /// The date and time when the model was created.
    public let createdAt: Date

    /// The date and time when the model was last updated.
    public let updatedAt: Date

    /// The name of the database table associated with the `LLMModelRecord`.
    public static var databaseTableName: String {
        "models"
    }

    // MARK: - GRDB Integration

    /// Updates the record with the unique identifier assigned upon insertion.
    ///
    /// - Parameter inserted: The result of the insertion operation.
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
