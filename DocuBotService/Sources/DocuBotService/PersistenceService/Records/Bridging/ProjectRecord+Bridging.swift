//
//  ProjectRecord+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension ProjectRecord {

    init(model: Project) {
        self.init(
            id: model.id,
            path: model.path,
            name: model.name,
            documentationChecksum: model.documentationChecksum,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

// MARK: - Model

public extension Project {

    init(record: ProjectRecord) {
        self.init(
            id: record.id,
            path: record.path,
            name: record.name,
            isDirty: false,
            documentationChecksum: record.documentationChecksum,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}
