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
        // GIVEN we have sample data
        let id = Int64(42)
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

        // WHEN we create a document with the sample data
        let document = Document(
            id: id,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            projectID: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // THEN the properties all line up
        #expect(document.id == id)
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
        // GIVEN we have a document with a local URL
        let document = Document.mock(
            url: URL(fileURLWithPath: "/path/to/document.txt")
        )

        // WHEN we extract the document title
        // THEN we get the correct value out
        #expect(document.documentTitle == "document.txt")
    }

    @Test("LLM Reference")
    func llmReference() {
        typealias Strings = L10n.Document.LlmReference

        // GIVEN we have a document with a local URL and content
        let url = URL(fileURLWithPath: "/path/to/document.txt")
        let content = "this is some content"
        let document = Document.mock(
            url: url,
            content: content
        )

        // WHEN we extract the LLM Reference
        // THEN we get the correct value out
        #expect(
            document.llmReference == Strings.template(url.path, content)
        )
    }

    @Test("Generate Checksum for Document Array")
    func generateChecksum() throws {
        // GIVEN we have an array of documents
        let documents: [Document] = [
            .mock(
                content: "Content of document 1"
            ),
            .mock(
                content: "Content of document 2"
            )
        ]

        // WHEN we generate the checksum for the array of documents
        let checksum = try documents.generateChecksum()

        // THEN we get the expected checksum
        #expect(
            checksum == "dd5bbde2584792a7ca5aa79863c50dc891ad785827f2e611d10074b813387402"
        )
    }

    @Test("DocumentError Description")
    func documentErrorDescription() {
        // GIVEN we have a missingID error
        let error = Document.DocumentError.missingID

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Document.missingID)
    }

    @Test("ChecksumGenerationError Description")
    func checksumGenerationErrorDescription() {
        // GIVEN we have a failedConversion error
        let error = Document.ChecksumGenerationError.failedConversion

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Document.checksumGeneration)
    }

    @Test("Equality")
    func equality() {
        // GIVEN we have two equal documents
        let equalDocument1 = Document.mock()
        let equalDocument2 = Document.mock()

        // THEN they should be seen as equal
        #expect(equalDocument1 == equalDocument2)

        // GIVEN we have two unequal documents
        let unequalDocument1 = Document.mock(content: "foo")
        let unequalDocument2 = Document.mock(content: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalDocument1 != unequalDocument2)
    }

    @Test("Equality Ignoring ID")
    func equalityIgnoringID() {
        // GIVEN we have two equal documents
        let equalDocument1 = Document.mock()
        let equalDocument2 = Document.mock()

        // THEN they should be seen as equal
        #expect(equalDocument1.isEqualToIgnoringID(equalDocument2))

        // GIVEN we have two unequal documents
        let unequalDocument1 = Document.mock(content: "foo")
        let unequalDocument2 = Document.mock(content: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalDocument1.isEqualToIgnoringID(unequalDocument2) == false)

        // GIVEN we have two equal documents apart from ID
        let document1 = Document.mock(id: 1)
        let document2 = Document.mock(id: 2)

        // THEN they should be seen as equal ignoring ID
        #expect(document1.isEqualToIgnoringID(document2))
    }

}
