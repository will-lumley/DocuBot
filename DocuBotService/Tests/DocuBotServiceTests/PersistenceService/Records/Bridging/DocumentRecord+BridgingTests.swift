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
        // Prepare sample data for Document
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

        // Convert to DocumentRecord
        let record = DocumentRecord(model: document)

        // Validate record properties
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
        // Prepare sample data for DocumentRecord
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

        // Convert to Document
        let model = Document(record: record)

        // Validate model properties
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
        // Prepare sample embedding data
        let modelEmbedding = Document.Embedding(
            chunk: "Sample chunk",
            embedding: [0.5, 0.6, 0.7]
        )

        // Convert to DocumentRecord.Embedding
        let recordEmbedding = DocumentRecord.Embedding(model: modelEmbedding)

        // Validate DocumentRecord.Embedding properties
        #expect(recordEmbedding.chunk == modelEmbedding.chunk)
        #expect(recordEmbedding.embedding == modelEmbedding.embedding)
    }

    @Test("Record to Model Embedding Bridging")
    func recordToModelEmbeddingBridging() throws {
        // Prepare sample embedding data
        let recordEmbedding = DocumentRecord.Embedding(
            chunk: "Sample chunk",
            embedding: [0.5, 0.6, 0.7]
        )

        // Convert back to Document.Embedding
        let modelEmbedding = Document.Embedding(record: recordEmbedding)

        // Validate Document.Embedding properties
        #expect(modelEmbedding.chunk == recordEmbedding.chunk)
        #expect(modelEmbedding.embedding == recordEmbedding.embedding)

        // Validate round-trip equality
        let convertedRecordEmbedding = DocumentRecord.Embedding(
            model: modelEmbedding
        )
        #expect(convertedRecordEmbedding == recordEmbedding)
    }

}
