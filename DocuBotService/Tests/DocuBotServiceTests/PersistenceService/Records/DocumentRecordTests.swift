//
//  DocumentRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import DocuBotModel
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
        // GIVEN we have our DB migrations
        let migrations = Index.migrations

        // GIVEN we perform our migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // GIVEN we have sample data
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

        // GIVEN we have a ProjectRecord to commit
        var project = ProjectRecord(model: .mock())

        // GIVEN we have a DocumentRecord to commit, with our sample data
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

        // WHEN we commit the records to the DB
        try dbQueue.write { db in
            try project.insert(db)
            try document.insert(db)
        }

        try dbQueue.read { db in
            // THEN we fetch our Document
            let fetchedDocument = try #require(
                try DocumentRecord.fetchOne(db)
            )

            // THEN our Document has been given an ID
            let newID = try #require(fetchedDocument.id)
            #expect(newID == 1)

            // THEN our FetchedDocument has the correct data filled out
            let fetchedDocumentModel = Document(record: fetchedDocument)
            let documentModel = Document(record: document)
            #expect(fetchedDocumentModel.isEqualToIgnoringID(documentModel))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        // GIVEN we have a DocumentRecord with no existing ID
        var testSubject = DocumentRecord(model: .mock())

        // WHEN we insert this Model into the DB
        // and SQLite gives it an ID of 42
        testSubject.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )

        // THEN we have been given the ID of 42
        #expect(testSubject.id == 42)
    }
}
