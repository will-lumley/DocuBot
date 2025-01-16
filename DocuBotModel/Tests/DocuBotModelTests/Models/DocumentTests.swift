//
//  DocumentTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Foundation
import Testing

struct DocumentTests {

    @Test("Document Initialization")
    func documentInitialization() {
        let url = URL(string: "https://example.com/document.txt")!
        let fileFormat = ProjectSettings.DocumentationFormat.rtf
        let content = "Sample document content"
        let checksum = "samplechecksum"
        let projectID: Int64 = 12345
        let embeddings = [
            Document.Embedding(
                chunk: "chunk1",
                embedding: [0.1, 0.2]
            )
        ]
        let createdAt = Date()
        let updatedAt = Date()

        let document = Document(
            id: 1,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            projectID: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        #expect(document.id == 1)
        #expect(document.url == url)
        #expect(document.fileFormat == fileFormat)
        #expect(document.content == content)
        #expect(document.checksum == checksum)
        #expect(document.projectID == projectID)
        #expect(document.embeddings == embeddings)
        #expect(document.createdAt == createdAt)
        #expect(document.updatedAt == updatedAt)
    }

    @Test("Document Title")
    func documentTitle() {
        let url = URL(string: "https://example.com/document.txt")!
        let document = Document(
            id: nil,
            url: url,
            fileFormat: .rtf,
            content: "Sample content",
            checksum: "checksum",
            projectID: 123,
            embeddings: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        #expect(document.documentTitle == "document.txt")
    }

    @Test("LLM Reference")
    func llmReference() {
        let url = URL(string: "https://example.com/document.txt")!
        let content = "Sample content"
        let document = Document(
            id: nil,
            url: url,
            fileFormat: .rtf,
            content: content,
            checksum: "checksum",
            projectID: 123,
            embeddings: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        let expectedReference = L10n.Document.LlmReference.template(url.path, content)
        #expect(document.llmReference == expectedReference)
    }

    @Test("Generate Checksum for Document Array")
    func generateChecksum() throws {
        let documents = [
            Document(
                id: nil,
                url: URL(string: "https://example.com/doc1.txt")!,
                fileFormat: .rtf,
                content: "Content of document 1",
                checksum: "checksum1",
                projectID: 123,
                embeddings: nil,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Document(
                id: nil,
                url: URL(string: "https://example.com/doc2.txt")!,
                fileFormat: .md,
                content: "Content of document 2",
                checksum: "checksum2",
                projectID: 123,
                embeddings: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]

        let combinedContent = "Content of document 1\nContent of document 2"
        let expectedChecksum = combinedContent.checksum

        let checksum = try documents.generateChecksum()

        #expect(checksum == expectedChecksum)
    }

    @Test("DocumentError Description")
    func documentErrorDescription() {
        let error = Document.DocumentError.missingID
        let description = error.errorDescription
        #expect(description == L10n.Error.Document.missingID)
    }

    @Test("ChecksumGenerationError Description")
    func checksumGenerationErrorDescription() {
        let error = Document.ChecksumGenerationError.failedConversion
        let description = error.errorDescription
        #expect(description == L10n.Error.Document.checksumGeneration)
    }

}
