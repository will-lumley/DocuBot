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

    public var id: Int64?
    public let content: String
    public let author: Author
    public let chat: Int64
    public let createdAt: Date

    public static var databaseTableName: String {
        "messages"
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }

}
