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

    init(model: Document.Embedding) {
        self.init(
            chunk: model.chunk,
            embedding: model.embedding
        )
    }

}

// MARK: - Model

public extension Document {

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

    init(record: DocumentRecord.Embedding) {
        self.init(
            chunk: record.chunk,
            embedding: record.embedding
        )
    }

}
