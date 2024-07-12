//
//  GRDBService.swift
//
//
//  Created by William Lumley on 10/12/2023.
//

import Foundation
import GRDB

class GRDBService: PersistenceService {

    // MARK: - Types

    // MARK: - Service

    static var key: ServiceKey {
        .persistenceStore
    }

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - PersistenceService

    init() {
        do {
            // Create our handle on the DB
            self.dbQueue = try DatabaseQueue(path: GRDBService.databasePath)

            // Migrate the migrations
            var migrator = DatabaseMigrator()
            let migrations = Index.migrations

            // Iterate through each migration
            for migration in migrations {
                migrator.registerMigration(migration.identifier) { db in
                    migration.perform(db: db)
                }
            }

        } catch let error {
            fatalError("Failed to initialise DB Queue. Error: \(error)")
        }
    }

    func getCodebases() async throws -> [CodebaseRecord] {
        return []
    }

}

// MARK: - Private

private extension GRDBService {

    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var databasePath: String {
        documentsDirectory
            .appendingPathComponent("database.sqlite")
            .path()
    }

}
