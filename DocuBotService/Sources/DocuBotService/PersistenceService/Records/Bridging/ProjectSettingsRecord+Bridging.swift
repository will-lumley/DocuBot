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
        let language = ProjectSettingsRecord.Language(model: model.language)

        self.init(
            id: model.id,
            project: model.projectID,
            supportedFormats: formats,
            respondWithDocumentsOnly: model.respondWithDocumentsOnly,
            language: language,
            seed: model.seed,
            topK: model.topK,
            topP: model.topP,
            contextLength: model.contextLength,
            temperature: model.temperature,
            batchSize: model.batchSize,
            stopSequence: model.stopSequence,
            maxTokenCount: model.maxTokenCount,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

public extension ProjectSettingsRecord.DocumentationFormat {

    init(model: ProjectSettings.DocumentationFormat) {
        switch model {
        case .html:
            self = .html
        case .md:
            self = .md
        case .rtf:
            self = .rtf
        case .txt:
            self = .txt
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettingsRecord.Language {

    init(model: ProjectSettings.Language) {
        switch model {
        case .english: self = .english
        case .espanol: self = .espanol
        }
    }

}

// MARK: - Model

public extension ProjectSettings {

    init(record: ProjectSettingsRecord) {
        let formats = record.supportedFormats.map(ProjectSettings.DocumentationFormat.init)
        let language = ProjectSettings.Language(record: record.language)

        self.init(
            id: record.id,
            projectID: record.project,
            supportedFormats: formats,
            respondWithDocumentsOnly: record.respondWithDocumentsOnly,
            language: language,
            seed: record.seed,
            topK: record.topK,
            topP: record.topP,
            contextLength: record.contextLength,
            temperature: record.temperature,
            batchSize: record.batchSize,
            stopSequence: record.stopSequence,
            maxTokenCount: record.maxTokenCount,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}

public extension ProjectSettings.DocumentationFormat {

    init(record: ProjectSettingsRecord.DocumentationFormat) {
        switch record {
        case .html:
            self = .html
        case .md:
            self = .md
        case .rtf:
            self = .rtf
        case .txt:
            self = .txt
        case .other(let string):
            self = .other(string)
        }
    }

}

public extension ProjectSettings.Language {

    init(record: ProjectSettingsRecord.Language) {
        switch record {
        case .english: self = .english
        case .espanol: self = .espanol
        }
    }

}
