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

    func insert(project: Project) async throws -> Project {
        return try await self.dbQueue.write { db in
            var record = ProjectRecord(model: project)
            try record.insert(db)

            return Project(record: record)
        }
    }

    func getProjects() -> AnyPublisher<[Project], Error> {
        return ValueObservation.tracking { db in
            try ProjectRecord.fetchAll(db)
        }
            .publisher(in: self.dbQueue)
            .map { $0.map(Project.init) }
            .eraseToAnyPublisher()
    }

    func delete(project: Project) async throws -> Bool {
        return try await self.dbQueue.write { db in
            try ProjectRecord.deleteOne(db, id: project.id)
        }
    }

    func insert(settings: ProjectSettings) async throws -> ProjectSettings {
        return try await self.dbQueue.write { db in
            var record = ProjectSettingsRecord(model: settings)
            try record.insert(db)

            return ProjectSettings(record: record)
        }
    }

    func getChats(for project: Project) -> AnyPublisher<[Chat], Error> {
        return ValueObservation.tracking { db in
             try ChatRecord.fetchAll(db)
                .filter { $0.project == project.id }
        }
            .publisher(in: self.dbQueue)
            .map { $0.map(Chat.init) }
            .eraseToAnyPublisher()
    }

    func insert(chat: Chat) async throws -> Chat {
        return try await self.dbQueue.write { db in
            var record = ChatRecord(model: chat)
            try record.insert(db)

            return Chat(record: record)
        }
    }

    func delete(chat: Chat) async throws -> Bool {
        try await self.dbQueue.write { db in
            try ChatRecord.deleteOne(db, id: chat.id)
        }
    }

    func update(chat: Chat) async throws {
        try await self.dbQueue.write { db in
            try ChatRecord(model: chat).update(db)
        }
    }

    func getMessages(for chat: Chat) -> AnyPublisher<[Message], Error> {
        return ValueObservation.tracking { db in
            try MessageRecord.fetchAll(db)
                .filter { $0.chat == chat.id }
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
            // Import all the projects
            try self.dbQueue.write { db in
                for var record in ProjectRecord.mocks() {
                    try record.insert(db)
                }
            }

            // Import all the chats
            try self.dbQueue.write { db in
                for var record in ChatRecord.mocks() {
                    try record.insert(db)
                }
            }

            // Import all the messages
            try self.dbQueue.write { db in
                try db.execute(sql: "PRAGMA foreign_keys = OFF")

                for var record in MessageRecord.mocks() {
                    try record.insert(db)
                }
            }
        } catch {
            print("Failed to inject demo data. \(error)")
        }
    }
    
}
