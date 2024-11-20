//
//  DocumentParserTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Foundation
import SimilaritySearchKit
import SimilaritySearchKitDistilbert
import Testing

// swiftlint:disable:next type_body_length
struct DocumentParserTests {

    // MARK: - Properties

    private var mockProject: Project
    private var mockSettings: ProjectSettings
    private var parser: DocumentParser

    private var onSyncUpdate: ((Int, Int) -> Void)?

    // MARK: - Lifecycle

    init() {
        self.mockProject = .mock()
        self.mockSettings = .mock()

        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )
    }

    // MARK: - Tests

    @Test("Create and Parse with No Bookmark Data")
    mutating func createAndParseWithNoBookmarkData() async {
        self.mockProject.urlBookmarkData = Data()
        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.createAndParse()
        }
    }

    @Test("Create and Parse with Stale Bookmark")
    mutating func createAndParseWithStaleBookmarkData() async {
        self.mockProject.urlBookmarkData = Data(repeating: 1, count: 10)
        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.createAndParse()
        }
    }

    @Test("Check Project Is Dirty with No Bookmark Data")
    mutating func checkProjectIsDirtyWithNoBookmarkData() async {
        // Assign invalid bookmark data
        self.mockProject.urlBookmarkData = Data()

        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.checkProjectIsDirty()
        }
    }

    @Test("Check Project Is Dirty with Stale Bookmark")
    mutating func checkProjectIsDirtyWithStaleBookmark() async {
        // Assign mock bookmark data
        self.mockProject.urlBookmarkData = Data(repeating: 1, count: 10)

        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.checkProjectIsDirty()
        }
    }

    @Test(
        "Valid Documentation File",
        arguments: ProjectSettings.DocumentationFormat.allPossibleCases
    )
    func validDocumentations(
        formats: [ProjectSettings.DocumentationFormat]
    ) {
        let mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: formats
        )

        let parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )
        let mdURL = URL(fileURLWithPath: "/path/to/document.md")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let exeURL = URL(fileURLWithPath: "/path/to/document.exe")

        let mdIsValid = parser.validDocumentation(at: mdURL)
        let rtfIsValid = parser.validDocumentation(at: rtfURL)
        let txtIsValid = parser.validDocumentation(at: txtURL)
        let htmlIsValid = parser.validDocumentation(at: htmlURL)
        let exeIsValid = parser.validDocumentation(at: exeURL)

        #expect(formats.contains(.md) == mdIsValid)
        #expect(formats.contains(.rtf) == rtfIsValid)
        #expect(formats.contains(.txt) == txtIsValid)
        #expect(formats.contains(.html) == htmlIsValid)
        #expect(exeIsValid == false)
    }

    @Test(
        "Valid Other Documentation File",
        arguments: [
            [
                ProjectSettings.DocumentationFormat.rtf,
                ProjectSettings.DocumentationFormat.html,
                ProjectSettings.DocumentationFormat.other("foo")
            ],
            [
                ProjectSettings.DocumentationFormat.md,
                ProjectSettings.DocumentationFormat.txt,
                ProjectSettings.DocumentationFormat.other("bar")
            ]
        ]
    )
    func validOtherDocumentations(
        formats: [ProjectSettings.DocumentationFormat]
    ) {
        let mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: formats
        )

        let parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )
        let mdURL = URL(fileURLWithPath: "/path/to/document.md")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let fooURL = URL(fileURLWithPath: "/path/to/document.foo")
        let barURL = URL(fileURLWithPath: "/path/to/document.bar")
        let exeURL = URL(fileURLWithPath: "/path/to/document.exe")

        let mdIsValid = parser.validDocumentation(at: mdURL)
        let rtfIsValid = parser.validDocumentation(at: rtfURL)
        let txtIsValid = parser.validDocumentation(at: txtURL)
        let htmlIsValid = parser.validDocumentation(at: htmlURL)
        let fooIsValid = parser.validDocumentation(at: fooURL)
        let barIsValid = parser.validDocumentation(at: barURL)
        let exeIsValid = parser.validDocumentation(at: exeURL)

        #expect(formats.contains(.md) == mdIsValid)
        #expect(formats.contains(.rtf) == rtfIsValid)
        #expect(formats.contains(.txt) == txtIsValid)
        #expect(formats.contains(.html) == htmlIsValid)
        #expect(formats.contains(.other("foo")) == fooIsValid)
        #expect(formats.contains(.other("bar")) == barIsValid)
        #expect(exeIsValid == false)
    }

    @Test("File Extension Parsing")
    func fileExtension() {
        let markdownURL = URL(fileURLWithPath: "/path/to/document.md")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let otherURL = URL(fileURLWithPath: "/path/to/document.docx")

        let mdFormat = self.parser.fileExtension(from: markdownURL)
        let txtFormat = self.parser.fileExtension(from: txtURL)
        let rtfFormat = self.parser.fileExtension(from: rtfURL)
        let htmlFormat = self.parser.fileExtension(from: htmlURL)
        let otherFormat = self.parser.fileExtension(from: otherURL)

        #expect(mdFormat == .md)
        #expect(txtFormat == .txt)
        #expect(rtfFormat == .rtf)
        #expect(htmlFormat == .html)
        #expect(otherFormat == .other("docx"))
    }

    @Test("Document Error Descriptions")
    func documentErrorDescriptions() {
        let noBookmarkError = DocumentParser.DocumentError.noBookmarkData
        let bookmarkStaleError = DocumentParser.DocumentError.bookmarkIsStale

        #expect(noBookmarkError.errorDescription == L10n.Error.Document.noBookmarkData)
        #expect(bookmarkStaleError.errorDescription == L10n.Error.Document.bookmarkIsStale)
    }

    @Test("Existing Documents")
    func existingDocuments() {
        let existingDocument = Document(
            id: 1,
            url: URL(fileURLWithPath: "/mock/file1.md"),
            fileFormat: .md,
            content: "This is the content of file1.",
            checksum: "checksum1",
            projectID: 1,
            embeddings: nil,
            createdAt: .now,
            updatedAt: .now
        )
        let newDocument = Document(
            id: 2,
            url: URL(fileURLWithPath: "/mock/file2.md"),
            fileFormat: .md,
            content: "This is the content of file1.",
            checksum: "checksum1",
            projectID: 1,
            embeddings: nil,
            createdAt: .now,
            updatedAt: .now
        )

        var mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: [.md]
        )
        mockProject.load(documents: [
            existingDocument
        ])

        var parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // We should find file1.md
        #expect(
            parser.existingDocument(with: existingDocument.url) != nil
        )

        // We should NOT find file2.md
        #expect(
            parser.existingDocument(with: newDocument.url) == nil
        )

        mockProject.load(documents: [
            existingDocument,
            newDocument
        ])
        parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // We should find file1.md
        #expect(
            parser.existingDocument(with: existingDocument.url) != nil
        )

        // We should find file2.md
        #expect(
            parser.existingDocument(with: newDocument.url) != nil
        )
    }

    @Test("OnSyncUpdate Called")
    func onSyncUpdateCalled() async throws {
        let document1 = Document(
            id: 1,
            url: URL(fileURLWithPath: "/mock/file1.md"),
            fileFormat: .md,
            content: "This is the content of file1.",
            checksum: "checksum1",
            projectID: 1,
            embeddings: nil,
            createdAt: .now,
            updatedAt: .now
        )
        let document2 = Document(
            id: 2,
            url: URL(fileURLWithPath: "/mock/file2.md"),
            fileFormat: .md,
            content: "This is the content of file1.",
            checksum: "checksum1",
            projectID: 1,
            embeddings: nil,
            createdAt: .now,
            updatedAt: .now
        )

        var mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: [.md]
        )
        mockProject.load(documents: [
            document1,
            document2
        ])

        struct SyncUpdate {
            let progress: Int
            let total: Int
        }

        var syncUpdates = [SyncUpdate]()
        let parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { progress, total in
                syncUpdates.append(
                    .init(progress: progress, total: total)
                )
            }
        )

        _ = try await parser.createAndParse()

        #expect(syncUpdates.count == 2)
        print("SyncUpdates: \(syncUpdates)")
    }

    @Test("Index Documents")
    func indexDocuments() async throws {
        // Mock documents to index
        let mockDocuments: [Document] = [
            Document(
                id: 1,
                url: URL(fileURLWithPath: "/mock/file1.md"),
                fileFormat: .md,
                content: "This is the content of file1.",
                checksum: "checksum1",
                projectID: 1,
                embeddings: nil,
                createdAt: .now,
                updatedAt: .now
            ),
            Document(
                id: 2,
                url: URL(fileURLWithPath: "/mock/file2.txt"),
                fileFormat: .txt,
                content: "This is the content of file2.",
                checksum: "checksum2",
                projectID: 1,
                embeddings: nil,
                createdAt: .now,
                updatedAt: .now
            )
        ]

        // Run the `index(documents:)` method
        let indexed = try await self.parser.index(documents: mockDocuments)

        #expect(indexed.count == mockDocuments.count)

//        for index in indexed {
//            #expect(
//                try #require(index.embeddings) == [
//                    .init(chunk: "123", embedding: [0.1])
//                ]
//            )
//        }

//        XCTAssertEqual(indexedDocuments.count, mockDocuments.count, "Number of indexed documents should match input documents.")
//        XCTAssertNotNil(indexedDocuments.first?.embeddings, "Indexed documents should contain embeddings.")
//        XCTAssertEqual(indexedDocuments.first?.checksum, "checksum1", "Checksums should match for already indexed documents.")
//        XCTAssertEqual(indexedDocuments.last?.embeddings?.first?.embedding.count, 10, "Embeddings should contain 10 values.")
    }

}

// MARK: - Project

private extension Project {

    static func mock(
        id: Int64 = 0,
        path: String = "",
        name: String = "",
        urlBookmarkData: Data = .init(),
        documentationCheckSum: String? = "123",
        exampleQuestions: [String] = ["what", "is"],
        alertStatus: Project.AlertStatus = .error(error: .firstSync),
        needsFullResync: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> Project {
        .init(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            documentationCheckSum: documentationCheckSum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            needsFullResync: needsFullResync,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}

// MARK: - ProjectSettings.DocumentationFormat

private extension ProjectSettings.DocumentationFormat {

    static var allPossibleCases: [[ProjectSettings.DocumentationFormat]] {
        [
            [],
            [.rtf],
            [.txt],
            [.html],
            [.md],
            [.rtf, .txt],
            [.rtf, .html],
            [.rtf, .md],
            [.txt, .html],
            [.txt, .md],
            [.html, .md],
            [.rtf, .txt, .html],
            [.rtf, .txt, .md],
            [.rtf, .html, .md],
            [.txt, .html, .md],
            [.rtf, .txt, .html, .md]
        ]
    }

}
