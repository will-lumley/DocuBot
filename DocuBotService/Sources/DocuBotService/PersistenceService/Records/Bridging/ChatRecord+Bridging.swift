//
//  Chat+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension ChatRecord {

    init(model: Chat) {
        self.init(
            id: model.id,
            name: model.name,
            project: model.projectID,
            createdAt: model.createdAt
        )
    }

}

// MARK: - Model

public extension Chat {

    init(record: ChatRecord) {
        self.init(
            id: record.id,
            name: record.name,
            projectID: record.project,
            createdAt: record.createdAt
        )
    }

}
