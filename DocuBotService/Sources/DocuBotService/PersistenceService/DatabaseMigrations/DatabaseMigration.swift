//
//  Migration.swift
//
//
//  Created by William Lumley on 18/6/2024.
//

import Foundation
import GRDB

/// A protocol defining the requirements for database migrations.
///
/// Conforming types represent individual migrations that can be applied to a database.
/// Each migration is uniquely identified and includes an action to be performed.
protocol DatabaseMigration {

    /// A typealias representing the action to be performed during the migration.
    ///
    /// The action is a closure that takes a `Database` instance and may throw an error.
    typealias DatabaseMigrationAction = (Database) throws -> Void

    /// A unique identifier for the migration.
    ///
    /// The identifier helps ensure that migrations are applied in the correct order and only once.
    var identifier: String { get }

    /// Performs the migration on the provided database.
    ///
    /// This method contains the logic to apply the migration to the database schema or data.
    ///
    /// - Parameter db: The `Database` instance on which the migration is performed.
    /// - Throws: An error if the migration fails.
    func perform(db: Database) throws

}
