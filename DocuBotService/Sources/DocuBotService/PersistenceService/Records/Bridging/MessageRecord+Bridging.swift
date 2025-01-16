//
//  Message+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension MessageRecord {

    init(model: Message) {
        self.init(
            id: model.id,
            content: model.content,
            author: .init(model: model.author),
            chat: model.chatID,
            createdAt: model.createdAt
        )
    }

}

public extension MessageRecord.Author {

    init(model: Message.Author) {
        switch model {
        case .docubot:
            self = .docubot
        case .user:
            self = .user
        }
    }

}

// MARK: - Model

public extension Message {

    init(record: MessageRecord) {
        self.init(
            id: record.id,
            content: record.content,
            author: .init(record: record.author),
            chatID: record.chat,
            createdAt: record.createdAt
        )
    }
}

public extension Message.Author {

    init(record: MessageRecord.Author) {
        switch record {
        case .docubot:
            self = .docubot
        case .user:
            self = .user
        }
    }

}
