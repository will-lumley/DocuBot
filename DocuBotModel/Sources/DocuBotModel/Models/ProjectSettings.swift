//
//  Project.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct ProjectSettings: Hashable {

    // MARK: - Types

    public enum DocumentationFormat: Hashable, CaseIterable {
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

    // MARK: - Lifecycle

    public init(
        id: Int,
        projectID: Int,
        supportedFormats: [DocumentationFormat],
        respondWithDocumentsOnly: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.projectID = projectID

        self.supportedFormats = supportedFormats
        self.respondWithDocumentsOnly = respondWithDocumentsOnly

        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}
