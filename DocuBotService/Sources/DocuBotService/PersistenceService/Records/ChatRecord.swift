//
//  ChatRecord.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

public struct ChatRecord: Record {

    // MARK: - Types

    public enum NameType: Hashable, Codable, Sendable {
        case userSet
        case docuBotSet
        case automatic
    }

    // MARK: - Properties

    public var id: Int64?
    public let name: String
    public let nameType: NameType
    public let project: Int64
    public let createdAt: Date

    public static var databaseTableName: String {
        "chats"
    }

    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
