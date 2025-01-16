//
//  ChatRecord.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

public struct ChatRecord: Record {

    // MARK: - Properties

    public let id: Int
    public let name: String
    public let project: Int
    public let createdAt: Date

    public static var databaseTableName: String {
        "chats"
    }

}
