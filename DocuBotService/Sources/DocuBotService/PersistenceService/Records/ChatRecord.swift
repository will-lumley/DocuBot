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

    public enum NameType: Hashable, Codable {
        case userSet
        case docuBotSet
        case automatic
    }

    // MARK: - Properties

    public var id: Int?
    public let name: String
    public let nameType: NameType
    public let project: Int
    public let createdAt: Date

    public static var databaseTableName: String {
        "chats"
    }

}
