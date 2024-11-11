//
//  LLMModelRecord+Bridging.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotModel

// MARK: - Record

public extension LLMModelRecord {

    init(model: LLMModel) {
        self.init(
            id: model.id,
            name: model.name,
            path: model.path,
            size: model.size,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

// MARK: - Model

public extension LLMModel {

    init(record: LLMModelRecord) {
        self.init(
            id: record.id,
            name: record.name,
            path: record.path,
            size: record.size,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}
