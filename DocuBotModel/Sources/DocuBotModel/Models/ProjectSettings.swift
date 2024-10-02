//
//  Project.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct ProjectSettings: Hashable, Codable {

    // MARK: - Types

    public enum Language: Hashable, CaseIterable, Codable {
        case english
        case espanol
    }

    public enum DocumentationFormat: Hashable, CaseIterable, Codable {
        public static var allCases: [ProjectSettings.DocumentationFormat] {
            [.rtf, .txt, .html, .md]
        }

        case rtf
        case txt
        case html
        case md
        case other(String)

        init(rawValue: String) {
            switch rawValue {
            case "rtf": self = .rtf
            case "txt": self = .txt
            case "html": self = .html
            case "md": self = .md
            default: self = .other(rawValue)
            }
        }
    }

    // MARK: - Properties

    public let id: Int64?
    public let projectID: Int64

    public let supportedFormats: [DocumentationFormat]
    public let respondWithDocumentsOnly: Bool
    public let language: Language

    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int64? = nil,
        projectID: Int64,
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

// MARK: - Public

public extension ProjectSettings {

    var otherFormats: [DocumentationFormat] {
        self.supportedFormats
            .filter { $0.isOther }
    }

    func isEnabled(_ format: DocumentationFormat) -> Bool {
        return self.supportedFormats.contains(format)
    }

}

// MARK: - ProjectSettings.DocumentationFormat

public extension ProjectSettings.DocumentationFormat {

    var isOther: Bool {
        switch self {
        case .other:
            return true
        default:
            return false
        }
    }

    var extensionName: String {
        switch self {
        case .html:
            return "html"
        case .md:
            return "md"
        case .txt:
            return "txt"
        case .rtf:
            return "rtf"
        case .other(let value):
            return value
        }
    }

}

// MARK: - ProjectSettings.Language

extension ProjectSettings.Language: Identifiable {

    public var id: Self {
        self
    }

}
