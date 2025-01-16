//
//  ProjectSettingsRecord+MockData.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation

extension ProjectSettingsRecord {

    static func mocks() -> [ProjectSettingsRecord] {
        return [
            .mock(
                id: 1,
                projectID: 1,
                supportedFormats: ProjectSettingsRecord.DocumentationFormat.allCases,
                respondWithDocumentsOnly: false,
                createdAt: .now,
                updatedAt: .now
            ),
            .mock(
                id: 2,
                projectID: 2,
                supportedFormats: [.md],
                respondWithDocumentsOnly: true,
                createdAt: .now,
                updatedAt: .now
            ),
            .mock(
                id: 3,
                projectID: 3,
                supportedFormats: [.txt, .rtf, .md],
                respondWithDocumentsOnly: false,
                createdAt: .now,
                updatedAt: .now
            ),
        ]
    }

    static func mock(
        id: Int = 0,
        projectID: Int = 0,
        supportedFormats: [DocumentationFormat] = DocumentationFormat.allCases,
        respondWithDocumentsOnly: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> ProjectSettingsRecord {
        .init(
            id: id,
            projectID: projectID,
            supportedFormats: supportedFormats,
            respondWithDocumentsOnly: respondWithDocumentsOnly,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
