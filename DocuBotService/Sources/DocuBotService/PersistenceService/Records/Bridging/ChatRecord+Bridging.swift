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
            nameType: .init(model: model.nameType),
            project: model.projectID,
            createdAt: model.createdAt
        )
    }

}

public extension ChatRecord.NameType {

    init(model: Chat.NameType) {
        switch model {
        case .automatic: self = .automatic
        case .docuBotSet: self = .docuBotSet
        case .userSet: self = .userSet
        }
    }

}

// MARK: - Model

public extension Chat {

    init(record: ChatRecord) {
        self.init(
            id: record.id,
            name: record.name,
            nameType: .init(record: record.nameType),
            projectID: record.project,
            createdAt: record.createdAt
        )
    }

}

public extension Chat.NameType {

    init(record: ChatRecord.NameType) {
        switch record {
        case .automatic: self = .automatic
        case .docuBotSet: self = .docuBotSet
        case .userSet: self = .userSet
        }
    }

}
