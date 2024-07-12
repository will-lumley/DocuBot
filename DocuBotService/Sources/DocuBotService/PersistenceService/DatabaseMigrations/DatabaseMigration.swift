//
//  Migration.swift
//
//
//  Created by William Lumley on 18/6/2024.
//

import Foundation
import GRDB

protocol DatabaseMigration {

    typealias DatabaseMigrationAction = (Database) throws -> Void

    var identifier: String { get }
    func perform(db: Database)

}
