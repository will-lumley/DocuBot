//
//  DatabaseFlags.swift
//
//
//  Created by William Lumley on 13/7/2023.
//

import Vexil

/// A container for feature flags related to the persistence service.
///
/// The `DatabaseFlags` struct defines and manages feature flags that control the behaviour
/// of the database and its operations.
public struct DatabaseFlags: FlagContainer {

    // MARK: - Flags

    /// A flag indicating whether the database should be erased on a schema change.
    ///
    /// When set to `true`, the database will be cleared whenever the schema changes.
    @Flag(default: false, description: "Erase Database On Schema Change")
    public var eraseDatabaseOnSchemaChange: Bool

    /// A flag indicating whether demo data should be injected into the database upon launch.
    ///
    /// When set to `true`, the database will be pre-populated with demo data.
    @Flag(default: false, description: "Injects demo data into the DB upon launch")
    public var injectDemoData: Bool

    // MARK: - Lifecycle

    /// Creates a new instance of `DatabaseFlags`.
    ///
    /// The initializer sets up the flags with their default values.
    public init() {
        // Intentionally left blank
    }

}
