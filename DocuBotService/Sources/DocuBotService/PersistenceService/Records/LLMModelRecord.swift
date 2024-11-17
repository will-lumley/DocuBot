//
//  LLMModelRecord.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation
import GRDB

public struct LLMModelRecord: Record {

    // MARK: - Properties

    public var id: Int64?
    public let name: String
    public let path: String
    public let size: Int64
    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "models"
    }

    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
