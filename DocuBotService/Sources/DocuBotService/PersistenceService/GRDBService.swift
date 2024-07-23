//
//  GRDBService.swift
//
//
//  Created by William Lumley on 10/12/2023.
//

import Combine
import Foundation
import GRDB
import DocuBotModel

class GRDBService: PersistenceService {

    // MARK: - Types

    // MARK: - Service

    static var key: ServiceKey {
        .persistenceStore
    }

    // MARK: - Properties

    private let dbQueue: DatabaseQueue
    private let serviceContainer: ServiceContainer

    private var flagService: FlagService {
        self.serviceContainer.flagService
    }

    private var logService: LogService {
        self.serviceContainer.logService
    }

    // MARK: - PersistenceService

    init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer

        do {
            // Create our handle on the DB
            self.dbQueue = try DatabaseQueue(path: GRDBService.databasePath)
        } catch let error {
            fatalError("Failed to initialise DB Queue. Error: \(error)")
        }

        self.runMigrations()
        self.injectDemoData()
    }

    func getProjects() -> AnyPublisher<[Project], Error> {
        return ValueObservation.tracking { db in
            try ProjectRecord.fetchAll(db)
        }
            .publisher(in: self.dbQueue)
            .map { $0.map(Project.init) }
            .eraseToAnyPublisher()
    }

    func getChats(for project: ProjectRecord) -> AnyPublisher<[Chat], Error> {
        return ValueObservation.tracking { db in
            try ChatRecord.fetchAll(db)
        }
            .publisher(in: self.dbQueue)
            .map { $0.map(Chat.init) }
            .eraseToAnyPublisher()
    }

    func getMessages(for chat: ChatRecord) -> AnyPublisher<[Message], Error> {
        return ValueObservation.tracking { db in
            try MessageRecord.fetchAll(db)
        }
            .publisher(in: self.dbQueue)
            .map { $0.map(Message.init) }
            .eraseToAnyPublisher()
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

    func runMigrations() {
        self.logService.log(with: .info, "DatabasePath: \(GRDBService.databasePath)")

        // Migrate the migrations
        var migrator = DatabaseMigrator()

        let eraseDatabaseOnSchemaChange = self.flagService.appFlags.database.eraseDatabaseOnSchemaChange
        migrator.eraseDatabaseOnSchemaChange = eraseDatabaseOnSchemaChange
        logService.log(with: .info, "EraseDatabaseOnSchemaChange: \(eraseDatabaseOnSchemaChange)")

        let migrations = Index.migrations

        // Iterate through each migration and register them
        for migration in migrations {
            migrator.registerMigration(migration.identifier) { db in
                do {
                    try migration.perform(db: db)
                } catch {
                    fatalError("MigrationRegistration Failed. ID: \(migration.identifier). \(error)")
                }
            }
        }

        // Now that we've registered our migrations, we can run them
        do {
            try migrator.migrate(self.dbQueue)
        } catch {
            fatalError("MigrationExecution Failed. ID: \(error)")
        }
    }

    func injectDemoData() {
        let injectDemoData = flagService.appFlags.database.injectDemoData
        logService.log(with: .info, "InjectDemoData: \(injectDemoData)")

        guard injectDemoData else {
            return
        }

        do {
            // Import all the messages
            try self.dbQueue.write { db in
                try MessageRecord.mocks().forEach {
                    try $0.insert(db)
                }
            }

            // Import all the chats
            try self.dbQueue.write { db in
                try ChatRecord.mocks().forEach {
                    try $0.insert(db)
                }
            }

            // Import all the projects
            try self.dbQueue.write { db in
                try ProjectRecord.mocks().forEach {
                    try $0.insert(db)
                }
            }
        } catch {
            fatalError("Failed to inject demo deta. \(error)")
        }
    }
    
}
