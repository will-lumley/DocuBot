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
@Suite("DocumentParserTests", .serialized)
struct DocumentParserTests {

    // MARK: - Properties

    private var mockProject: Project
    private var mockSettings: ProjectSettings
    private var parser: DocumentParser

    private var onSyncUpdate: ((Int, Int) -> Void)?

    // MARK: - Lifecycle

    init() {
        guard let projectDirectory = try? Self.createTestProjectAndDocuments(
            with: [.txt, .rtf, .html, .md, .pdf]
        ) else {
            fatalError()
        }

        // Let's create BookmarkData to access it
        guard let bookmarkData = try? projectDirectory.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        ) else {
            fatalError()
        }

        self.mockProject = .mock(
            path: projectDirectory.path(),
            urlBookmarkData: bookmarkData
        )
        self.mockSettings = .mock(
            supportedFormats: [.txt, .rtf, .html, .md, .pdf]
        )

        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )
    }

    // MARK: - Tests

    @Test("Create and Parse with No Bookmark Data")
    mutating func createAndParseWithNoBookmarkData() async {
        // GIVEN that our Project has no valid data
        self.mockProject.urlBookmarkData = Data()
        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // WHEN we try and parse
        // THEN we get the correct error thrown
        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.createAndParse()
        }
    }

    @Test("Create and Parse with Stale Bookmark")
    mutating func createAndParseWithStaleBookmarkData() async {
        // GIVEN that our Project has invalid data
        self.mockProject.path = "/path/to/invalid/bookmark"
        self.mockProject.urlBookmarkData = Data(repeating: 1, count: 10)
        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // WHEN we try and parse
        // THEN we get the correct error thrown
        await #expect(throws: DocumentParser.DocumentError.bookmarkIsStale) {
            try await self.parser.createAndParse()
        }
    }

    @Test("Create and Parse", .disabled("CI Flakiness"))
    mutating func createAndParse() async throws {
        // WHEN we parse ALL our documents
        let syncResult = try await self.parser.createAndParse()

        // THEN our checksum is correctly set
        let expectedChecksum = "ab7c498b7135c0df28f83f2d46e2e80f432f807fa676a3c1f7ce9cb1555a5c6a"
        #expect(syncResult.checksum == expectedChecksum)

        // THEN we have the correct amount of documents returned
        #expect(syncResult.documents.count == 5)

        let html = syncResult.documents[0]
        let txt  = syncResult.documents[1]
        let md   = syncResult.documents[2]
        let pdf  = syncResult.documents[3]
        let rtf  = syncResult.documents[4]

        // Using the static helper functions to create the comparison
        // document means we're only comparing the equality of the
        // document content and document embeddings value

        // THEN the .html document is correctly created
        #expect(
            html == Self.testHtmlDocument(
                url: html.url,
                createdAt: html.createdAt,
                updatedAt: html.updatedAt
            )
        )

        // THEN the .txt document is correctly created
        #expect(
            txt == Self.testTxtDocument(
                url: txt.url,
                createdAt: txt.createdAt,
                updatedAt: txt.updatedAt
            )
        )

        // THEN the .md document is correctly created
        #expect(
            md == Self.testMdDocument(
                url: md.url,
                createdAt: md.createdAt,
                updatedAt: md.updatedAt
            )
        )

        // THEN the .rtf document is correctly created
        #expect(
            rtf == Self.testRtfDocument(
                url: rtf.url,
                createdAt: rtf.createdAt,
                updatedAt: rtf.updatedAt
            )
        )

        // THEN the .pdf document is correctly created
        #expect(
            pdf == Self.testPdfDocument(
                url: pdf.url,
                createdAt: pdf.createdAt,
                updatedAt: pdf.updatedAt
            )
        )
    }

    @Test("Check Project Is Dirty with No Bookmark Data")
    mutating func checkProjectIsDirtyWithNoBookmarkData() async {
        // GIVEN that our Project has no data
        self.mockProject.urlBookmarkData = Data()
        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // WHEN we try and check if the project is dirty
        // THEN we get the correct error thrown
        await #expect(throws: DocumentParser.DocumentError.noBookmarkData) {
            try await self.parser.checkProjectIsDirty()
        }
    }

    @Test("Check Project Is Dirty with Stale Bookmark")
    mutating func checkProjectIsDirtyWithStaleBookmark() async {
        // GIVEN that our Project has invalid data
        self.mockProject.urlBookmarkData = Data(repeating: 1, count: 10)
        self.parser = DocumentParser(
            project: self.mockProject,
            settings: self.mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // WHEN we try and check if the project is dirty
        // THEN we get the correct error thrown
        await #expect(throws: DocumentParser.DocumentError.bookmarkIsStale) {
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
        // GIVEN we have a mock project and settings
        let mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: formats
        )

        // GIVEN we have a DocumentParser
        let parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // GIVEN we have URLs to documentation types
        let mdURL = URL(fileURLWithPath: "/path/to/document.md")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let exeURL = URL(fileURLWithPath: "/path/to/document.exe")

        // WHEN we check if each documentation type is valid
        let mdIsValid = parser.validDocumentation(at: mdURL)
        let rtfIsValid = parser.validDocumentation(at: rtfURL)
        let txtIsValid = parser.validDocumentation(at: txtURL)
        let htmlIsValid = parser.validDocumentation(at: htmlURL)
        let exeIsValid = parser.validDocumentation(at: exeURL)

        // THEN we ensure that each of them is valid based off of
        // the test arguments
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
        // GIVEN we have a mock project and settings
        let mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: formats
        )

        // GIVEN we have a DocumentParser
        let parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // GIVEN we have URLs to documentation types
        let mdURL = URL(fileURLWithPath: "/path/to/document.md")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let fooURL = URL(fileURLWithPath: "/path/to/document.foo")
        let barURL = URL(fileURLWithPath: "/path/to/document.bar")
        let exeURL = URL(fileURLWithPath: "/path/to/document.exe")

        // WHEN we check if each documentation type is valid
        let mdIsValid = parser.validDocumentation(at: mdURL)
        let rtfIsValid = parser.validDocumentation(at: rtfURL)
        let txtIsValid = parser.validDocumentation(at: txtURL)
        let htmlIsValid = parser.validDocumentation(at: htmlURL)
        let fooIsValid = parser.validDocumentation(at: fooURL)
        let barIsValid = parser.validDocumentation(at: barURL)
        let exeIsValid = parser.validDocumentation(at: exeURL)

        // THEN we ensure that each of them is valid based off of
        // the test arguments
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
        // GIVEN we have various file paths to different documentation types
        let markdownURL = URL(fileURLWithPath: "/path/to/document.md")
        let txtURL = URL(fileURLWithPath: "/path/to/document.txt")
        let rtfURL = URL(fileURLWithPath: "/path/to/document.rtf")
        let htmlURL = URL(fileURLWithPath: "/path/to/document.html")
        let pdfURL = URL(fileURLWithPath: "/path/to/document.pdf")
        let wordURL = URL(fileURLWithPath: "/path/to/document.docx")
        let otherURL = URL(fileURLWithPath: "/path/to/document.other")

        // WHEN we extract the documentation type
        let mdFormat = self.parser.fileExtension(from: markdownURL)
        let txtFormat = self.parser.fileExtension(from: txtURL)
        let rtfFormat = self.parser.fileExtension(from: rtfURL)
        let htmlFormat = self.parser.fileExtension(from: htmlURL)
        let pdfFormat = self.parser.fileExtension(from: pdfURL)
        let wordFormat = self.parser.fileExtension(from: wordURL)
        let otherFormat = self.parser.fileExtension(from: otherURL)

        // THEN the documentation type is correctly set
        #expect(mdFormat == .md)
        #expect(txtFormat == .txt)
        #expect(rtfFormat == .rtf)
        #expect(htmlFormat == .html)
        #expect(pdfFormat == .pdf)
        #expect(wordFormat == .word)
        #expect(otherFormat == .other("other"))
    }

    @Test("Document Error Descriptions")
    func documentErrorDescriptions() {
        // GIVEN we have our errors
        let noBookmarkError = DocumentParser.DocumentError.noBookmarkData
        let bookmarkStaleError = DocumentParser.DocumentError.bookmarkIsStale

        // THEN our descriptions match up
        #expect(noBookmarkError.errorDescription == L10n.Error.Document.noBookmarkData)
        #expect(bookmarkStaleError.errorDescription == L10n.Error.Document.bookmarkIsStale)
    }

    @Test("Existing Documents")
    func existingDocuments() {
        // GIVEN we have an existing Document
        let existingDocument = Document.mock(
            id: 1,
            url: URL(fileURLWithPath: "/mock/file1.md"),
            projectID: 1
        )

        // GIVEN we have a new Document
        let newDocument = Document.mock(
            id: 2,
            url: URL(fileURLWithPath: "/mock/file2.md"),
            projectID: 1
        )

        // GIVEN we have a Project and Settings
        var mockProject = Project.mock()
        let mockSettings = ProjectSettings.mock(
            supportedFormats: [.md]
        )

        // GIVEN we've only loaded in the existing document
        mockProject.load(documents: [
            existingDocument
        ])

        // WHEN we setup a parser
        var parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // THEN we find the existing document
        #expect(
            parser.existingDocument(with: existingDocument.url) == existingDocument
        )

        // THEN we do NOT find the new document
        #expect(
            parser.existingDocument(with: newDocument.url) == nil
        )

        // GIVEN we load in the existing document and new document
        mockProject.load(documents: [
            existingDocument,
            newDocument
        ])

        // GIVEN we recreate our parser
        parser = DocumentParser(
            project: mockProject,
            settings: mockSettings,
            onSyncUpdate: { _, _ in }
        )

        // THEN we find the existing document
        #expect(
            parser.existingDocument(with: existingDocument.url) == existingDocument
        )

        // THEN we also find the new document
        #expect(
            parser.existingDocument(with: newDocument.url) == newDocument
        )
    }

}

// MARK: - Private

private extension DocumentParserTests {

    static func createTestProjectAndDocuments(
        with types: [ProjectSettings.DocumentationFormat]
    ) throws -> URL {
        let fileManager = FileManager.default

        // Let's create a new directory to call our own
        let testURL = fileManager
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project3/")

        try fileManager.createDirectory(
            at: testURL,
            withIntermediateDirectories: true
        )

        if types.contains(.txt) {
            // Add a test .txt to our project directory
            fileManager.createFile(
                atPath: testURL
                    .appendingPathComponent("test1.txt", conformingTo: .text)
                    .path(),
                contents: "Hello, World!".data(using: .utf8)
            )
        }

        if types.contains(.md) {
            // Add a test .md to our project directory
            fileManager.createFile(
                atPath: testURL
                    .appendingPathComponent("test2.md", conformingTo: .text)
                    .path(),
                contents: "## Hello, World!".data(using: .utf8)
            )
        }

        if types.contains(.html) {
            // Add a test .html to our project directory
            fileManager.createFile(
                atPath: testURL
                    .appendingPathComponent("test3.html", conformingTo: .text)
                    .path(),
                contents: "<html><body>Hello, World!</body></html>".data(using: .utf8)
            )
        }

        if types.contains(.pdf) {
            // Add a test .pdf to our project directory
            let origin = Self.testPdfUrl
            let destination = testURL.appendingPathComponent(
                "test.pdf",
                conformingTo: .pdf
            )

            if fileManager.fileExists(atPath: destination.path()) == false {
                try fileManager.copyItem(
                    at: origin,
                    to: destination
                )
            }
        }

        if types.contains(.rtf) {
            // Add a test .rtf to our project directory
            let origin = Self.testRtfUrl
            let destination = testURL.appendingPathComponent(
                "test.rtf",
                conformingTo: .rtf
            )

            if fileManager.fileExists(atPath: destination.path()) == false {
                try fileManager.copyItem(
                    at: origin,
                    to: destination
                )
            }
        }

        return testURL
    }

    /// This will fetch our local test PDF.
    ///
    /// - Returns: The URL for our test PDF.
    static var testPdfUrl: URL {
        guard let path = Bundle.module.path(
            forResource: "test",
            ofType: "pdf"
        ) else {
            fatalError()
        }

        return URL(fileURLWithPath: path)
    }

    /// This will fetch our local test RTF.
    ///
    /// - Returns: The URL for our test RTF.
    static var testRtfUrl: URL {
        guard let path = Bundle.module.path(
            forResource: "test",
            ofType: "rtf"
        ) else {
            fatalError()
        }

        return URL(fileURLWithPath: path)
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
