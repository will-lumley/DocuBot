//
//  ProjectRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import DocuBotModel
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
        // GIVEN we have our DB migrations
        let migrations = Index.migrations

        // GIVEN we perform our migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // GIVEN we have sample data
        let path = "/path/to/project"
        let name = "Sample Project"
        let urlBookmarkData = Data("SampleBookmark".utf8)
        let documentationChecksum: String? = "abc123checksum"
        let exampleQuestions = ["What is this project?", "How do I use it?"]
        let alertStatus = ProjectRecord.AlertStatus.warning(warning: .directoryChanged)
        let needsFullResync = false
        let createdAt = Date()
        let updatedAt = Date()

        // GIVEN we have our Project to commit, with our sample data
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

        // WHEN we commit the records to the DB
        try dbQueue.write { db in
            try project.insert(db)
        }

        try dbQueue.read { db in
            // THEN we fetch our Project
            let fetchedProject = try #require(
                try ProjectRecord.fetchOne(db)
            )

            // THEN our Project has been given an ID
            let newID = try #require(fetchedProject.id)
            #expect(newID == 1)

            // THEN our FetchedProjectSettings has the correct data filled out
            let fetchedProjectModel = Project(record: fetchedProject)
            let projectModel = Project(record: project)
            #expect(fetchedProjectModel.isEqualToIgnoringID(projectModel))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        // GIVEN we have a ProjectRecord with no existing ID
        var testSubject = ProjectRecord(model: .mock())

        // WHEN we insert this Project into the DB
        // and SQLite gives it an ID of 42
        testSubject.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )

        // THEN we have been given the ID of 42
        #expect(testSubject.id == 42)
    }

}
