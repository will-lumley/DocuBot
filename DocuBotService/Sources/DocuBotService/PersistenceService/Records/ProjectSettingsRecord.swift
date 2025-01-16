//
//  ProjectSettingsRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation
import GRDB

public struct ProjectSettingsRecord: Record {

    // MARK: - Types

    public enum Language: String, Hashable, Codable {
        case english
        case espanol
    }

    public enum DocumentationFormat: Hashable, Codable, CaseIterable {
        public static var allCases: [ProjectSettingsRecord.DocumentationFormat] {
            [.rtf, .txt, .html, .md]
        }

        case rtf
        case txt
        case html
        case md
        case other(String)
    }

    // MARK: - Properties

    public var id: Int64?
    public let project: Int64

    public let supportedFormats: [DocumentationFormat]
    public let respondWithDocumentsOnly: Bool
    public let language: Language

    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "project-settings"
    }

    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
