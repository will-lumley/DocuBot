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

    public let id: Int?
    public let path: String
    public let name: String
    public let documentationChecksum: String
    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "projects"
    }

}
