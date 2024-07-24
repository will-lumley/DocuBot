//
//  Message.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct Message: Hashable {

    // MARK: - Types

    public enum Author: Hashable, Codable {
        case docubot
        case user
    }

    // MARK: - Properties

    public let id: Int
    public let content: String
    public let author: Author
    public let chatID: Int
    public let createdAt: Date

    // MARK: - Lifecycle

    public init(id: Int, content: String, author: Author, chatID: Int, createdAt: Date) {
        self.id = id
        self.content = content
        self.author = author
        self.chatID = chatID
        self.createdAt = createdAt
    }

}
