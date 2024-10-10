//
//  Chat.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct Chat: Hashable, Codable, Sendable {

    // MARK: - Types

    public enum NameType: Hashable, Codable, Sendable {
        case userSet
        case docuBotSet
        case automatic
    }

    // MARK: - Properties

    public let id: Int64?
    public let name: String
    public let nameType: NameType
    public let projectID: Int64
    public private(set) var messages = [Message]()
    public let createdAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int64? = nil,
        name: String,
        nameType: NameType,
        projectID: Int64,
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.nameType = nameType
        self.projectID = projectID
        self.createdAt = createdAt
    }

}

// MARK: - Public

public extension Chat {

    mutating func load(messages: [Message]) {
        self.messages = messages
    }

}
