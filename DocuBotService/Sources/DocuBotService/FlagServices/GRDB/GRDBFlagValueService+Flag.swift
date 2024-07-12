//
//  GRDBFlagValueService+Flag.swift
//  
//
//  Created by William Lumley on 7/11/2023.
//

import Foundation
import GRDB

public extension GRDBFlagValueService {

    struct Flag: Codable, FetchableRecord, PersistableRecord, TableRecord {

        // MARK: - Properties

        let key: String
        let value: Data
        let hashValue: Int

        // MARK: - Lifecycle

        init(key: String, value: Data) {
            self.key = key
            self.value = value

            var hasher = Hasher()
            hasher.combine(value)
            self.hashValue = hasher.finalize()
        }

        // MARK: - Columns

        enum Columns {
            static let key = Column(CodingKeys.key)
            static let value = Column(CodingKeys.value)
            static let hashValue = Column(CodingKeys.hashValue)
        }

        // MARK: - Table

        public static var databaseTableName: String {
            "flags"
        }

    }

}
