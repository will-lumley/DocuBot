//
//  DocumentRecord.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

public struct DocumentRecord: Record {

    // MARK: - Types

    public struct Embedding: Hashable, Codable, Sendable {
        public let chunk: String
        public let embedding: [Float]
    }

    // MARK: - Properties

    public var id: Int64?
    public let url: URL
    public let fileFormat: ProjectSettingsRecord.DocumentationFormat
    public let content: String
    public let project: Int64
    public let embeddings: [DocumentRecord.Embedding]?
    public let createdAt: Date
    public let updatedAt: Date

    public static var databaseTableName: String {
        "documents"
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }

}
