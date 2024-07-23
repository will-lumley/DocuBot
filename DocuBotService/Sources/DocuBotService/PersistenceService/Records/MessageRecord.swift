//
//  MessageRecord.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

public struct MessageRecord: Record {

    // MARK: - Types

    public enum Author: Hashable, Codable {
        case docubot
        case user
    }

    // MARK: - Properties

    public let id: Int
    public let content: String
    public let author: Author
    public let chat: Int
    public let createdAt: Date

    public static var databaseTableName: String {
        "messages"
    }

}
