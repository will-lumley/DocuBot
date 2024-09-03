//
//  Message.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct Message: Hashable, Codable {

    // MARK: - Types

    public enum Author: Hashable, Codable {
        case docubot
        case user
    }

    // MARK: - Properties

    public let id: Int64?
    public let content: String
    public let author: Author
    public let chatID: Int64
    public let createdAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int64? = nil,
        content: String,
        author: Author,
        chatID: Int64,
        createdAt: Date
    ) {
        self.id = id
        self.content = content
        self.author = author
        self.chatID = chatID
        self.createdAt = createdAt
    }

}
