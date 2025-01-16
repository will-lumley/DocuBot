//
//  LLMModelRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
@testable import GRDB
import Testing

struct LLMModelRecordTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Database Table Name")
    func databaseTableName() {
        #expect(LLMModelRecord.databaseTableName == "models")
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
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        // GIVEN we have our Model to commit, with our sample data
        var model = LLMModelRecord(
            id: nil,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we commit the records to the DB
        try dbQueue.write { db in
            try model.insert(db)
        }

        try dbQueue.read { db in
            // THEN we fetch our Model
            let fetchedModel = try #require(
                try LLMModelRecord.fetchOne(db)
            )

            // THEN our Model has been given an ID
            let newID = try #require(fetchedModel.id)
            #expect(newID == 1)

            // THEN our FetchedProjectSettings has the correct data filled out
            let fetchedLLMModel = LLMModel(record: fetchedModel)
            let modelModel = LLMModel(record: model)
            #expect(fetchedLLMModel.isEqualToIgnoringID(modelModel))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        // GIVEN we have a LLMModelRecord with no existing ID
        var testSubject = LLMModelRecord(model: .mock())

        // WHEN we insert this Model into the DB
        // and SQLite gives it an ID of 42
        testSubject.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )

        // THEN we have been given the ID of 42
        #expect(testSubject.id == 42)
    }
}
