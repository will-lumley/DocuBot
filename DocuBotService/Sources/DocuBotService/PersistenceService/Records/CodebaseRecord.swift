//
//  CodebaseRecord.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import GRDB

public struct CodebaseRecord: Codable, FetchableRecord, PersistableRecord {
    public let path: String
}
