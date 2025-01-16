//
//  Acknowledgement+Tests.swift
//  DocuBotModelTests
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Foundation
import Testing

struct AcknowledgementTests {

    // MARK: - Tests

    @Test("Initializer Success")
    func initializerSuccess() throws {
        // GIVEN we have an acknowledgement
        let acknowledgement = Acknowledgement(
            author: "Test Author",
            libraryName: "Test Library",
            description: "Test Description",
            linkStr: "https://example.com",
            license: "Test License"
        )

        // THEN all the properties are correctly set
        #expect(acknowledgement != nil)
        #expect(acknowledgement?.author == "Test Author")
        #expect(acknowledgement?.libraryName == "Test Library")
        #expect(acknowledgement?.description == "Test Description")
        #expect(acknowledgement?.link.absoluteString == "https://example.com")
        #expect(acknowledgement?.license == "Test License")
    }

    @Test("Initializer Failure - Invalid URL")
    func initializerFailureInvalidURL() throws {
        // GIVEN we have an acknowledgement with an invalid URL
        let acknowledgement = Acknowledgement(
            author: "Test Author",
            libraryName: "Test Library",
            description: "Test Description",
            linkStr: "invalid-url",
            license: "Test License"
        )

        // THEN no acknowledgement is returned at all
        #expect(acknowledgement == nil)
    }

    @Test("All Acknowledgements")
    // swiftlint:disable:next function_body_length
    func allAcknowledgements() throws {
        // GIVEN we have gathered ALL of our acknowledgements
        let acknowledgements = Acknowledgement.all

        // THEN we have the expected acknowledgements
        #expect(acknowledgements.isEmpty == false)
        #expect(acknowledgements.count == 10)

        // Define expected values for all acknowledgements
        // swiftlint:disable line_length large_tuple
        let expectedAcknowledgements: [(author: String, libraryName: String, description: String, link: String, license: String)] = [
            (
                author: "unsignedapps",
                libraryName: "Vexil",
                description: "A Swift Package that manages feature flags in a flexible, multi-provider way.",
                link: "https://github.com/unsignedapps/Vexil",
                license: "MIT"
            ),
            (
                author: "groue",
                libraryName: "GRDB.swift",
                description: """
                A Swift Package that provides a high-level API for performing database operations, \
                making it easy to integrate SQLite into Swift applications with type safety and efficiency.
                """,
                link: "https://github.com/groue/GRDB.swift.git",
                license: "MIT"
            ),
            (
                author: "eastriverlee",
                libraryName: "LLM.swift",
                description: """
                A Swift Package that provides a Swift-y API wrapper to llama.cpp.
                """,
                link: "https://github.com/eastriverlee/LLM.swift",
                license: "MIT"
            ),
            (
                author: "ggerganov",
                libraryName: "llama.cpp",
                description: """
                Inference of Meta's LLaMA model (and others) in pure C/C++.
                """,
                link: "https://github.com/ggerganov/llama.cpp.git",
                license: "MIT"
            ),
            (
                author: "SFSafeSymbols",
                libraryName: "SFSafeSymbols",
                description: """
                A Swift package that allows SFSymbols to be accessible in a type safe, enumerated, format.
                """,
                link: "https://github.com/SFSafeSymbols/SFSafeSymbols",
                license: "MIT"
            ),
            (
                author: "Zach Nagengast",
                libraryName: "similarity-search-kit",
                description: """
                A Swift package enabling on-device text embeddings and semantic search functionality.
                """,
                link: "https://github.com/ZachNagengast/similarity-search-kit.git",
                license: "Apache 2.0"
            ),
            (
                author: "SwiftfulThinking",
                libraryName: "Swiftful Loading Indicators",
                description: """
                A collection of lightweight loading animations that can be applied to any SwiftUI view with 1 line of code.
                """,
                link: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git",
                license: "N/A"
            ),
            (
                author: "gonzalezreal",
                libraryName: "swift-markdown-ui",
                description: """
                MarkdownUI is a powerful library for displaying and customizing Markdown text in SwiftUI.
                """,
                link: "https://github.com/gonzalezreal/swift-markdown-ui",
                license: "MIT"
            ),
            (
                author: "SwiftGen",
                libraryName: "SwiftGen",
                description: """
                A tool that generates Swift code for accessing app resources like images, colors, and strings in a type-safe way.
                """,
                link: "https://github.com/SwiftGen/SwiftGenPlugin",
                license: "MIT"
            ),
            (
                author: "Realm",
                libraryName: "Swift Lint",
                description: """
                A tool to enforce Swift style and conventions, loosely based on the now archived GitHub Swift Style Guide.
                """,
                link: "https://github.com/realm/SwiftLint",
                license: "MIT"
            )
        ]
        // swiftlint:enable line_length

        // THEN all of our acknowledgements have the correct values
        for (index, expected) in expectedAcknowledgements.enumerated() {
            let acknowledgement = acknowledgements[index]
            let expectedAcknowledgement = Acknowledgement(
                author: expected.author,
                libraryName: expected.libraryName,
                description: expected.description,
                linkStr: expected.link,
                license: expected.license
            )
            #expect(acknowledgement == expectedAcknowledgement)
        }
    }
    @Test("Acknowledgement Links Validity")
    func acknowledgementLinksValidity() throws {
        // GIVEN we have gathered ALL of our acknowledgements
        let acknowledgements = Acknowledgement.all

        // THEN all of our acknowledgements have valid URLs
        for acknowledgement in acknowledgements {
            #expect(URL(string: acknowledgement.link.absoluteString) != nil)
        }
    }
}
