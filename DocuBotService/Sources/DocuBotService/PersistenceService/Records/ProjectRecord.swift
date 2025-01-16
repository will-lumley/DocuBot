//
//  ProjectRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation
import GRDB

/// A database record representing a project.
///
/// The `ProjectRecord` struct defines the properties and behaviors of a project stored in the database,
/// including metadata, alert statuses, and other attributes.
public struct ProjectRecord: Record {

    // MARK: - Properties

    /// The unique identifier for the project.
    ///
    /// This value is assigned by the database upon insertion.
    public var id: Int64?

    /// The file path associated with the project.
    public let path: String

    /// The name of the project.
    public let name: String

    /// The bookmark data for the project's URL.
    ///
    /// This data can be used to reconstruct the URL for the project file.
    public let urlBookmarkData: Data

    /// The checksum of the project's documentation.
    ///
    /// This value is used to track changes in the project's documentation files.
    public var documentationChecksum: String?

    /// A list of example questions associated with the project.
    public var exampleQuestions: [String]

    /// The current alert status of the project.
    ///
    /// This status indicates warnings or errors that may affect the project's state.
    public var alertStatus: AlertStatus

    /// The date and time when the project was created.
    public let createdAt: Date

    /// The date and time when the project was last updated.
    public let updatedAt: Date

    /// The name of the database table associated with the `ProjectRecord`.
    public static var databaseTableName: String {
        "projects"
    }

    // MARK: - GRDB Integration

    /// Updates the record with the unique identifier assigned upon insertion.
    ///
    /// - Parameter inserted: The result of the insertion operation.
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
