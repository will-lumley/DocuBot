//
//  Index.swift
//
//
//  Created by William Lumley on 2/7/2024.
//

import Foundation

/// A struct that manages the database migrations for the application.
///
/// The `Index` struct provides a centralised way to define and access all database migrations
/// that need to be applied to the database.
struct Index {

    /// A list of all the database migrations to be applied.
    ///
    /// This array contains instances of types conforming to the `DatabaseMigration` protocol,
    /// defining the steps required to update the database schema or data over time.
    ///
    /// - Returns: An array of `DatabaseMigration` instances.
    static var migrations: [any DatabaseMigration] {
        [
            Initial()
        ]
    }

}
