//
//  DocumentRecord+BridgingTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotModel
@testable import DocuBotService
import Foundation
import GRDB
import Testing

struct DocumentRecordBridgingTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Model to Record Bridging")
    func modelToRecordBridging() throws {
        // GIVEN we have sample data
        let url = try #require(URL(string: "https://example.com/document"))
        let fileFormat = ProjectSettings.DocumentationFormat.md
        let content = "Sample document content"
        let checksum = "abc123"
        let projectID: Int64 = 1
        let embeddings = [
            Document.Embedding(chunk: "Chunk 1", embedding: [0.1, 0.2]),
            Document.Embedding(chunk: "Chunk 2", embedding: [0.3, 0.4])
        ]
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Document in the Model layer
        let document = Document(
            id: 42,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            projectID: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Document to the Storage layer
        let record = DocumentRecord(model: document)

        // THEN there is no data losss
        #expect(record.id == document.id)
        #expect(record.url == document.url)
        #expect(record.fileFormat == .init(model: fileFormat))
        #expect(record.content == document.content)
        #expect(record.checksum == document.checksum)
        #expect(record.project == document.projectID)
        #expect(record.embeddings == document.embeddings?.map(DocumentRecord.Embedding.init))
        #expect(record.createdAt == document.createdAt)
        #expect(record.updatedAt == document.updatedAt)
    }

    @Test("Record to Model Bridging")
    func recordToModelBridging() throws {
        // GIVEN we have sample data
        let url = try #require(URL(string: "https://example.com/document"))
        let fileFormat = ProjectSettingsRecord.DocumentationFormat.md
        let content = "Sample document content"
        let checksum = "abc123"
        let projectID: Int64 = 1
        let embeddings = [
            DocumentRecord.Embedding(chunk: "Chunk 1", embedding: [0.1, 0.2]),
            DocumentRecord.Embedding(chunk: "Chunk 2", embedding: [0.3, 0.4])
        ]
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Document in the Storage layer
        let record = DocumentRecord(
            id: 42,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            project: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Document to the Model layer
        let model = Document(record: record)

        // THEN there is no data losss
        #expect(model.id == record.id)
        #expect(model.url == record.url)
        #expect(model.fileFormat == .init(record: fileFormat))
        #expect(model.content == record.content)
        #expect(model.checksum == record.checksum)
        #expect(model.projectID == record.project)
        #expect(model.embeddings == record.embeddings?.map(Document.Embedding.init))
        #expect(model.createdAt == record.createdAt)
        #expect(model.updatedAt == record.updatedAt)
    }

    @Test("Model to Record Embedding Bridging")
    func modelToRecordEmbeddingBridging() throws {
        // GIVEN we have an embedding in the Model layer
        let modelEmbedding = Document.Embedding(
            chunk: "Sample chunk",
            embedding: [0.5, 0.6, 0.7]
        )

        // WHEN we bridge the embedding to the Storage layer
        let recordEmbedding = DocumentRecord.Embedding(model: modelEmbedding)

        // THEN there is no data loss
        #expect(recordEmbedding.chunk == modelEmbedding.chunk)
        #expect(recordEmbedding.embedding == modelEmbedding.embedding)
    }

    @Test("Record to Model Embedding Bridging")
    func recordToModelEmbeddingBridging() throws {
        // GIVEN we have an embedding in the Storage layer
        let recordEmbedding = DocumentRecord.Embedding(
            chunk: "Sample chunk",
            embedding: [0.5, 0.6, 0.7]
        )

        // WHEN we bridge the embedding to the Model layer
        let modelEmbedding = Document.Embedding(record: recordEmbedding)

        // THEN there is no data loss
        #expect(modelEmbedding.chunk == recordEmbedding.chunk)
        #expect(modelEmbedding.embedding == recordEmbedding.embedding)
    }

}
