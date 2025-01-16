//
//  Project.swift
//  
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct Project: Hashable {

    // MARK: - Properties

    public let id: Int
    public let path: String
    public let name: String
    public var chats = [Chat]()
    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Lifecycle

    public init(id: Int, path: String, name: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.path = path
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Project {

    mutating func load(chats: [Chat]) {
        self.chats = chats
    }

}
