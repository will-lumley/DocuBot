//
//  LLMModelRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

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
        // Run the migrations
        let migrations = Index.migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // Prepare sample data
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        // Insert an LLMModelRecord
        var model = LLMModelRecord(
            id: nil,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        try dbQueue.write { db in
            try model.insert(db)
        }

        // Verify that the record was inserted and fetched correctly
        try dbQueue.read { db in
            let fetchedModel = try #require(
                try LLMModelRecord.fetchOne(db)
            )

            // A new ID has been assigned
            let newID = try #require(fetchedModel.id)
            #expect(newID == 1)
            #expect(fetchedModel.name == name)
            #expect(fetchedModel.path == path)
            #expect(fetchedModel.size == size)
            #expect(Int(fetchedModel.createdAt.timeIntervalSince1970) == Int(createdAt.timeIntervalSince1970))
            #expect(Int(fetchedModel.updatedAt.timeIntervalSince1970) == Int(updatedAt.timeIntervalSince1970))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        var model = LLMModelRecord(
            id: nil,
            name: "GPT-4",
            path: "/models/gpt-4",
            size: 1024 * 1024 * 1024, // 1 GB
            createdAt: Date(),
            updatedAt: Date()
        )

        // Simulate the didInsert behaviour
        model.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )
        #expect(model.id == 42)
    }
}
