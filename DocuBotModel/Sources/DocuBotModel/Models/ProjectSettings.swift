//
//  Project.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct ProjectSettings: Hashable {

    // MARK: - Types

    public enum Language: Hashable, CaseIterable {
        case english
        case espanol
    }

    public enum DocumentationFormat: Hashable, CaseIterable {
        public static var allCases: [ProjectSettings.DocumentationFormat] {
            [.rtf, .txt, .html, .md]
        }

        case rtf
        case txt
        case html
        case md
        case other(String)
    }

    // MARK: - Properties

    public let id: Int
    public let projectID: Int

    public let supportedFormats: [DocumentationFormat]
    public let respondWithDocumentsOnly: Bool
    public let language: Language

    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int,
        projectID: Int,
        supportedFormats: [DocumentationFormat],
        respondWithDocumentsOnly: Bool,
        language: Language,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.projectID = projectID

        self.supportedFormats = supportedFormats
        self.respondWithDocumentsOnly = respondWithDocumentsOnly
        self.language = language

        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - ProjectSettings.Language

extension ProjectSettings.Language: Identifiable {

    public var id: Self {
        self
    }

}
