//
//  ProjectRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Foundation
@testable import GRDB
import Testing

struct ProjectRecordTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Database Table Name")
    func databaseTableName() {
        #expect(ProjectRecord.databaseTableName == "projects")
    }

    @Test("Insert and Fetch")
    func insertAndFetch() throws {
        // Run the migrations
        let migrations = Index.migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // Prepare sample data
        let path = "/path/to/project"
        let name = "Sample Project"
        let urlBookmarkData = Data("SampleBookmark".utf8)
        let documentationChecksum: String? = "abc123checksum"
        let exampleQuestions = ["What is this project?", "How do I use it?"]
        let alertStatus = ProjectRecord.AlertStatus.warning(warning: .directoryChanged)
        let needsFullResync = false
        let createdAt = Date()
        let updatedAt = Date()

        // Insert a ProjectRecord
        var project = ProjectRecord(
            id: nil,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            documentationChecksum: documentationChecksum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            needsFullResync: needsFullResync,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        try dbQueue.write { db in
            try project.insert(db)
        }

        // Verify that the record was inserted and fetched correctly
        try dbQueue.read { db in
            let fetchedProject = try #require(
                try ProjectRecord.fetchOne(db)
            )

            // A new ID has been assigned
            let newID = try #require(fetchedProject.id)
            #expect(newID == 1)
            #expect(fetchedProject.path == path)
            #expect(fetchedProject.name == name)
            #expect(fetchedProject.urlBookmarkData == urlBookmarkData)
            #expect(fetchedProject.documentationChecksum == documentationChecksum)
            #expect(fetchedProject.exampleQuestions == exampleQuestions)
            #expect(fetchedProject.alertStatus == alertStatus)
            #expect(fetchedProject.needsFullResync == needsFullResync)
            #expect(Int(fetchedProject.createdAt.timeIntervalSince1970) == Int(createdAt.timeIntervalSince1970))
            #expect(Int(fetchedProject.updatedAt.timeIntervalSince1970) == Int(updatedAt.timeIntervalSince1970))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        var project = ProjectRecord(
            id: nil,
            path: "/path/to/project",
            name: "Sample Project",
            urlBookmarkData: Data("SampleBookmark".utf8),
            documentationChecksum: nil,
            exampleQuestions: [],
            alertStatus: .warning(warning: .directoryChanged),
            needsFullResync: false,
            createdAt: Date(),
            updatedAt: Date()
        )

        // Simulate the didInsert behaviour
        project.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )
        #expect(project.id == 42)
    }
}
