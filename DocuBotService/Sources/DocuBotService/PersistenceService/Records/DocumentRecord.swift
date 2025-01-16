//
//  DocumentRecord.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import GRDB

/// A database record representing a document.
///
/// The `DocumentRecord` struct defines the properties and behaviors of a document stored in the database,
/// including metadata, content, and optional embeddings.
public struct DocumentRecord: Record {

    // MARK: - Types

    /// Represents an embedding associated with a document.
    ///
    /// An embedding includes a chunk of text and its corresponding vector representation.
    public struct Embedding: Hashable, Codable, Sendable {
        /// A chunk of text from the document.
        public let chunk: String

        /// The vector representation of the text chunk.
        public let embedding: [Float]
    }

    // MARK: - Properties

    /// The unique identifier for the document.
    ///
    /// This value is assigned by the database upon insertion.
    public var id: Int64?

    /// The URL of the document.
    public let url: URL

    /// The file format of the document.
    public let fileFormat: ProjectSettingsRecord.DocumentationFormat

    /// The content of the document as a plain text string.
    public let content: String

    /// The checksum of the document's content.
    ///
    /// This is used to detect changes in the document.
    public let checksum: String

    /// The identifier of the project associated with the document.
    public let project: Int64

    /// An optional array of embeddings for the document.
    ///
    /// Each embedding represents a chunk of the document and its vector representation.
    public let embeddings: [DocumentRecord.Embedding]?

    /// The date and time when the document was created.
    public let createdAt: Date

    /// The date and time when the document was last updated.
    public let updatedAt: Date

    /// The name of the database table associated with the `DocumentRecord`.
    public static var databaseTableName: String {
        "documents"
    }

    // MARK: - GRDB Integration

    /// Updates the record with the unique identifier assigned upon insertion.
    ///
    /// - Parameter inserted: The result of the insertion operation.
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }

}
