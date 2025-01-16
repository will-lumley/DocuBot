//
//  ProjectRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import Foundation
import GRDB

public struct ProjectRecord: Record {

    // MARK: - Properties

    public var id: Int64?
    public let path: String
    public let name: String
    public let urlBookmarkData: Data
    public var exampleQuestions: [String]
    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "projects"
    }

    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
