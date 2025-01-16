//
//  GRDBFlagValueService+Migration.swift
//
//
//  Created by William Lumley on 7/11/2023.
//

import GRDB

extension GRDBFlagValueService {

    func migrate(database: DatabaseWriter, isInitialAttempt: Bool = true) throws {
        do {
            var migrator = DatabaseMigrator()
            migrator.registerMigration("setup", migrate: self.migrationSetup(on:))

            try migrator.migrate(database)
        } catch {
            guard isInitialAttempt else {
                fatalError("Critically failed to migrate the flag database: \(error)")
            }

            try database.erase()
            try migrate(database: database, isInitialAttempt: false)
        }
    }

}

// MARK: - Migrations

private extension GRDBFlagValueService {

    func migrationSetup(on database: Database) throws {
        try database.create(table: GRDBFlagValueService.Flag.databaseTableName) { table in
            table.column("key", .text).primaryKey()
            table.column("value", .text).notNull()
            table.column("hashvalue", .integer).notNull()
        }
    }

}
