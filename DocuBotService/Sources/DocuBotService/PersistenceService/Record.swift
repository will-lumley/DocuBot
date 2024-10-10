//
//  Record.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import GRDB
import Foundation

public protocol Record: Sendable, Identifiable, Codable, Hashable, TableRecord, FetchableRecord, MutablePersistableRecord {
    
}
