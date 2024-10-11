//
//  Record.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

// swiftlint:disable:next line_length
public protocol Record: Sendable, Identifiable, Codable, Hashable, TableRecord, FetchableRecord, MutablePersistableRecord {

}
