//
//  DatabaseFlags.swift
//
//
//  Created by William Lumley on 13/7/2023.
//

import Vexil

public struct DatabaseFlags: FlagContainer {

    // MARK: - Flags

    @Flag(default: false, description: "Erase Database On Schema Change")
    public var eraseDatabaseOnSchemaChange: Bool

    @Flag(default: false, description: "Injects demo data into the DB upon launch")
    public var injectDemoData: Bool

    // MARK: - Lifecycle

    public init() {
        // Intentionally left blank
    }
}
