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

    public enum DocumentationFormat: Hashable, Codable, CaseIterable {
        case rtf
        case txt
        case html
        case md
    }

    // MARK: - Properties

    public let id: Int
    public let projectID: Int

    public let supportedFormats: [DocumentationFormat]
    public let respondWithDocumentsOnly: Bool

    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "project-settings"
    }

}
