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

    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }

}
