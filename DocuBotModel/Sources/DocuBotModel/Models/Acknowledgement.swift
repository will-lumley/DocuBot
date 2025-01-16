//
//  Acknowledgement.swift
//  DocuBotModel
//
//  Created by William Lumley on 11/11/2024.
//

import Foundation

public struct Acknowledgement {

    // MARK: - Properties

    public let author: String
    public let libraryName: String
    public let description: String
    public let link: URL
    public let license: String

    // MARK: - Lifecycle

    public init?(
        author: String,
        libraryName: String,
        description: String,
        linkStr: String,
        license: String
    ) {
        guard let link = URL(string: linkStr) else {
            return nil
        }

        self.author = author
        self.libraryName = libraryName
        self.description = description
        self.link = link
        self.license = license
    }

}

// MARK: - Public

public extension Acknowledgement {

    // swiftlint:disable line_length
    static var all: [Acknowledgement] {
        [
            .init(
                author: "unsignedapps",
                libraryName: "Vexil",
                description: """
                A Swift Package that manages feature flags in a flexible, multi-provider way.
                """,
                linkStr: "https://github.com/unsignedapps/Vexil",
                license: "MIT"
            ),
            .init(
                author: "groue",
                libraryName: "GRDB.swift",
                description: """
                A Swift Package that provides a high-level API for performing database operations, making it easy to integrate SQLite into Swift applications with type safety and efficiency.
                """,
                linkStr: "https://github.com/groue/GRDB.swift.git",
                license: "MIT"
            ),
            .init(
                author: "Shenghai Wang",
                libraryName: "SwiftLlama",
                description: """
                A Swift Package that provides a Swift-y API wrapper to llama.cpp.
                """,
                linkStr: "https://github.com/ShenghaiWang/SwiftLlama",
                license: "MIT"
            ),
            .init(
                author: "ggerganov",
                libraryName: "llama.cpp",
                description: """
                Inference of Meta's LLaMA model (and others) in pure C/C++.
                """,
                linkStr: "https://github.com/ggerganov/llama.cpp.git",
                license: "MIT"
            ),
            .init(
                author: "SFSafeSymbols",
                libraryName: "SFSafeSymbols",
                description: """
                A Swift package that allows SFSymbols to be accessible in a type safe, enumerated, format.
                """,
                linkStr: "https://github.com/SFSafeSymbols/SFSafeSymbols",
                license: "MIT"
            ),
            .init(
                author: "Zach Nagengast",
                libraryName: "similarity-search-kit",
                description: """
                A Swift package enabling on-device text embeddings and semantic search functionality.
                """,
                linkStr: "https://github.com/ZachNagengast/similarity-search-kit.git",
                license: "Apache 2.0"
            ),
            .init(
                author: "SwiftfulThinking",
                libraryName: "Swiftful Loading Indicators",
                description: """
                A collection of lightweight loading animations that can be applied to any SwiftUI view with 1 line of code.
                """,
                linkStr: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git",
                license: "N/A"
            ),
            .init(
                author: "gonzalezreal",
                libraryName: "swift-markdown-ui",
                description: """
                MarkdownUI is a powerful library for displaying and customizing Markdown text in SwiftUI.
                """,
                linkStr: "https://github.com/gonzalezreal/swift-markdown-ui",
                license: "MIT"
            ),
            .init(
                author: "Air BnB",
                libraryName: "Lottie",
                description: """
                Lottie loads and renders animations and vectors exported in the bodymovin JSON format.
                """,
                linkStr: "https://github.com/airbnb/lottie-ios.git",
                license: "Apache 2.0"
            ),
            .init(
                author: "SwiftGen",
                libraryName: "SwiftGen",
                description: """
                A tool that generates Swift code for accessing app resources like images, colors, and strings in a type-safe way.
                """,
                linkStr: "https://github.com/SwiftGen/SwiftGenPlugin",
                license: "MIT"
            ),
            .init(
                author: "Realm",
                libraryName: "Swift Lint",
                description: """
                A tool to enforce Swift style and conventions, loosely based on the now archived GitHub Swift Style Guide.
                """,
                linkStr: "https://github.com/realm/SwiftLint",
                license: "MIT"
            )
        ].compactMap(\.self)
    }
    // swiftlint:enable line_length

}
