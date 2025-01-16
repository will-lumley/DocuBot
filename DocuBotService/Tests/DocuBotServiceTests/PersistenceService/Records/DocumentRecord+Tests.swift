//
//  DocumentRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Foundation
@testable import GRDB
import Testing

struct DocumentRecordTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Database Table Name")
    func databaseTableName() {
        #expect(DocumentRecord.databaseTableName == "documents")
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
        let url = try #require(URL(string: "https://example.com/document"))
        let fileFormat = ProjectSettingsRecord.DocumentationFormat.rtf
        let content = "Sample content"
        let checksum = "12345abcde"
        let projectID: Int64 = 1
        let embeddings = [
            DocumentRecord.Embedding(
                chunk: "Sample chunk",
                embedding: [0.1, 0.2, 0.3]
            )
        ]
        let createdAt = Date()
        let updatedAt = Date()

        // Insert a document record
        var document = DocumentRecord(
            id: nil,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            project: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        try dbQueue.write { db in
            try document.insert(db)
        }

        // Verify that the record was inserted and fetched correctly
        try dbQueue.read { db in
            let fetchedDocument = try #require(
                try DocumentRecord.fetchOne(db)
            )

            // A new ID has been assigned
            let newID = try #require(fetchedDocument.id)
            #expect(newID == 1)
            #expect(fetchedDocument.url == url)
            #expect(fetchedDocument.fileFormat == fileFormat)
            #expect(fetchedDocument.content == content)
            #expect(fetchedDocument.checksum == checksum)
            #expect(fetchedDocument.project == projectID)
            #expect(fetchedDocument.embeddings == embeddings)
            #expect(Int(fetchedDocument.createdAt.timeIntervalSince1970) == Int(createdAt.timeIntervalSince1970))
            #expect(Int(fetchedDocument.updatedAt.timeIntervalSince1970) == Int(updatedAt.timeIntervalSince1970))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        var document = DocumentRecord(
            id: nil,
            url: URL(string: "https://example.com/document")!,
            fileFormat: .rtf,
            content: "Sample content",
            checksum: "12345abcde",
            project: 1,
            embeddings: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        // Simulate the didInsert behaviour
        document.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )
        #expect(document.id == 42)
    }
}
