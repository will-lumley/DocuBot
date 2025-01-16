//
//  ProjectSettingsRecord+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension ProjectSettingsRecord {

    init(model: ProjectSettings) {
        let formats = model.supportedFormats.map(ProjectSettingsRecord.DocumentationFormat.init)

        self.init(
            id: model.id,
            projectID: model.projectID,
            supportedFormats: formats,
            respondWithDocumentsOnly: model.respondWithDocumentsOnly,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

public extension ProjectSettingsRecord.DocumentationFormat {

    init(model: ProjectSettings.DocumentationFormat) {
        switch model {
        case .html: self = .html
        case .md: self = .md
        case .rtf: self = .rtf
        case .txt: self = .txt
        }
    }

}

// MARK: - Model

public extension ProjectSettings {

    init(record: ProjectSettingsRecord) {
        let formats = record.supportedFormats.map(ProjectSettings.DocumentationFormat.init)

        self.init(
            id: record.id,
            projectID: record.projectID,
            supportedFormats: formats,
            respondWithDocumentsOnly: record.respondWithDocumentsOnly,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}

public extension ProjectSettings.DocumentationFormat {

    init(record: ProjectSettingsRecord.DocumentationFormat) {
        switch record {
        case .html: self = .html
        case .md: self = .md
        case .rtf: self = .rtf
        case .txt: self = .txt
        }
    }

}
