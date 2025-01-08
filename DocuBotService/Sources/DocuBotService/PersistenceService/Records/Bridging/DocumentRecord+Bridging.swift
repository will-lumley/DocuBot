//
//  Message+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension DocumentRecord {

    /// Initializes a `DocumentRecord` from a `Document` model.
    ///
    /// This initializer converts a `Document` instance into its corresponding `DocumentRecord` representation,
    /// including all properties such as content, embeddings, and metadata.
    ///
    /// - Parameter model: The `Document` model to convert.
    init(model: Document) {
        self.init(
            id: model.id,
            url: model.url,
            fileFormat: .init(model: model.fileFormat),
            content: model.content,
            checksum: model.checksum,
            project: model.projectID,
            embeddings: model.embeddings?.map(DocumentRecord.Embedding.init),
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}

public extension DocumentRecord.Embedding {

    /// Initializes a `DocumentRecord.Embedding` from a `Document.Embedding` model.
    ///
    /// This initializer converts a `Document.Embedding` instance into its corresponding
    ///  `DocumentRecord.Embedding` representation.
    ///
    /// - Parameter model: The `Document.Embedding` model to convert.
    init(model: Document.Embedding) {
        self.init(
            chunk: model.chunk,
            embedding: model.embedding
        )
    }
}

// MARK: - Model

public extension Document {

    /// Initializes a `Document` model from a `DocumentRecord`.
    ///
    /// This initializer converts a `DocumentRecord` instance into its corresponding `Document` model,
    /// including all properties such as content, embeddings, and metadata.
    ///
    /// - Parameter record: The `DocumentRecord` to convert.
    init(record: DocumentRecord) {
        self.init(
            id: record.id,
            url: record.url,
            fileFormat: .init(record: record.fileFormat),
            content: record.content,
            checksum: record.checksum,
            projectID: record.project,
            embeddings: record.embeddings?.map(Document.Embedding.init),
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }
}

public extension Document.Embedding {

    /// Initializes a `Document.Embedding` model from a `DocumentRecord.Embedding`.
    ///
    /// This initializer converts a `DocumentRecord.Embedding` instance into its corresponding
    /// `Document.Embedding` representation.
    ///
    /// - Parameter record: The `DocumentRecord.Embedding` to convert.
    init(record: DocumentRecord.Embedding) {
        self.init(
            chunk: record.chunk,
            embedding: record.embedding
        )
    }
}
