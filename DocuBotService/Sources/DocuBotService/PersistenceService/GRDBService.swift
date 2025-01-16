//
//  GRDBService.swift
//
//
//  Created by William Lumley on 10/12/2023.
//

import Combine
import DocuBotModel
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

    // MARK: Projects

    func insert(project: Project) async throws -> Project {
        return try await self.dbQueue.write { db in
            var record = ProjectRecord(model: project)
            try record.insert(db)

            return Project(record: record)
        }
    }

    func getProject(id: Int64) async throws -> Project {
        return try await dbQueue.read { db in
            let request = ProjectRecord.filter(Column("id") == id)
            guard let record = try ProjectRecord.fetchOne(db, request) else {
                throw PersistenceError.valueNotFound
            }

            return Project(record: record)
        }
    }

    func getProject(id: Int64) -> AnyPublisher<Project, Never> {
        return ValueObservation.tracking { db in
            let request = ProjectRecord.filter(Column("id") == id)
            return try ProjectRecord.fetchOne(db, request)
        }
        .publisher(in: self.dbQueue)
        .replaceError(with: nil)
        .compactMap { $0 }
        .map(Project.init)
        .eraseToAnyPublisher()
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

    func update(project: Project) async throws -> Project {
        return try await self.dbQueue.write { db in
            let record = ProjectRecord(model: project)
            try record.update(db)

            return Project(record: record)
        }
    }

    // MARK: ProjectSettings

    func insert(settings: ProjectSettings) async throws -> ProjectSettings {
        return try await self.dbQueue.write { db in
            var record = ProjectSettingsRecord(model: settings)
            try record.insert(db)

            return ProjectSettings(record: record)
        }
    }

    func getProjectSettings(for project: Project) async throws -> ProjectSettings {
        return try await dbQueue.read { db in
            let request = ProjectSettingsRecord.filter(Column("project") == project.id)
            guard let record = try ProjectSettingsRecord.fetchOne(db, request) else {
                throw PersistenceError.valueNotFound
            }

            return ProjectSettings(record: record)
        }
    }

    func update(settings: ProjectSettings) async throws -> ProjectSettings {
        return try await self.dbQueue.write { db in
            let record = ProjectSettingsRecord(model: settings)
            try record.update(db)

            return ProjectSettings(record: record)
        }
    }

    // MARK: Documents

    func getDocuments(ids: [Int64]) async throws -> [Document] {
        return try await dbQueue.read { db in
            let records = try DocumentRecord.fetchAll(db, ids: ids)
            return records.map(Document.init)
        }
    }

    func getDocuments(for project: Project) async throws -> [Document] {
        return try await dbQueue.read { db in
            let request = DocumentRecord.filter(Column("project") == project.id)
            let records = try DocumentRecord.fetchAll(db, request)

            return records.map(Document.init)
        }
    }

    func insert(documents: [Document]) async throws -> [Document] {
        return try await self.dbQueue.write { db in
            var insertedDocuments = [Document]()

            for document in documents {
                var record = DocumentRecord(model: document)
                try record.insert(db)
                let insertedDocument = Document(record: record)
                insertedDocuments.append(insertedDocument)
            }

            return insertedDocuments
        }
    }

    func delete(documents: [Document]) async throws -> Int {
        return try await self.dbQueue.write { db in
            let ids = documents.compactMap(\.id)
            return try DocumentRecord.deleteAll(db, keys: ids)
        }
    }

    // MARK: Models

    func getModelCount() -> AnyPublisher<Int?, Never> {
        return ValueObservation.tracking { db in
            return try ModelRecord.fetchCount(db)
        }
        .publisher(in: self.dbQueue)
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }

    func getModels() -> AnyPublisher<[Model], any Error> {
        return ValueObservation.tracking { db in
            return try ModelRecord.fetchAll(db)
        }
        .publisher(in: self.dbQueue)
        .map { $0.map(Model.init) }
        .eraseToAnyPublisher()
    }

    func getModels() async throws -> [Model] {
        return try await dbQueue.read { db in
            let records = try ModelRecord.fetchAll(db)
            return records.map(Model.init)
        }
    }

    func getModel(id: Int64) async throws -> Model {
        return try await dbQueue.read { db in
            let request = ModelRecord.filter(Column("id") == id)
            guard let record = try ModelRecord.fetchOne(db, request) else {
                throw PersistenceError.valueNotFound
            }

            return Model(record: record)
        }
    }

    func insert(model: Model) async throws -> Model {
        return try await self.dbQueue.write { db in
            var record = ModelRecord(model: model)
            try record.insert(db)

            return Model(record: record)
        }
    }

    func update(model: Model) async throws -> Model {
        return try await self.dbQueue.write { db in
            let record = ModelRecord(model: model)
            try record.update(db)

            return Model(record: record)
        }
    }

    func delete(model: Model) async throws -> Bool {
        return try await self.dbQueue.write { db in
            let success = try ModelRecord.deleteOne(db, id: model.id)
            // If we successfully deleted this row, delete the
            // corressponding path
            if success {
                try FileManager.default.removeItem(
                    atPath: model.path
                )
            }
            return success
        }
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
            // Import all the models
            try self.dbQueue.write {db in
                for var record in ModelRecord.mocks() {
                    try record.insert(db)
                }
            }

        } catch {
            // swiftlint:disable:next direct_print
            print("Failed to inject demo data. \(error)")
        }
    }

}
