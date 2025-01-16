//
//  Initial.swift
//
//
//  Created by William Lumley on 18/6/2024.
//

import GRDB

struct Initial: DatabaseMigration {

    var identifier: String {
        "0001_Initial"
    }

    func perform(db: Database) throws {
        // Create projects table
        try db.create(table: "projects") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("path", .text)
                .notNull()
            table.column("name", .text)
                .notNull()
            table.column("documentationChecksum", .text)
            table.column("urlBookmarkData", .blob)
                .notNull()
            table.column("exampleQuestions", .blob)
                .notNull()
            table.column("alertStatus", .blob)
                .notNull()
            table.column("needsFullResync", .boolean)
                .notNull()
            table.column("createdAt", .datetime)
                .notNull()
            table.column("updatedAt", .datetime)
                .notNull()
        }

        // Create documents table
        try db.create(table: "documents") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("url", .text)
                .notNull()
            table.column("project", .integer)
                .notNull()
            table.column("fileFormat", .blob)
                .notNull()
            table.column("content", .text)
                .notNull()
            table.column("checksum", .text)
                .notNull()
            table.column("embeddings", .blob)
            table.column("createdAt", .datetime)
                .notNull()
            table.column("updatedAt", .datetime)
                .notNull()
        }

        // Create projects settings table
        try db.create(table: "project-settings") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("project", .integer)
                .notNull()
                .references("projects", onDelete: .cascade)
            table.column("supportedFormats", .blob)
                .notNull()
            table.column("strictMode", .boolean)
                .notNull()
            table.column("language", .text)
                .notNull()
            table.column("systemPrompt", .text)
                .notNull()
            table.column("embeddingModel", .blob)
                .notNull()
            table.column("similarityMetric", .blob)
                .notNull()
            table.column("seed", .integer)
                .notNull()
            table.column("topK", .integer)
                .notNull()
            table.column("topP", .double)
                .notNull()
            table.column("contextLength", .integer)
                .notNull()
            table.column("temperature", .double)
                .notNull()
            table.column("batchSize", .integer)
                .notNull()
            table.column("stopSequence", .text)
            table.column("maxTokenCount", .integer)
                .notNull()
            table.column("createdAt", .datetime)
                .notNull()
            table.column("updatedAt", .datetime)
                .notNull()
        }
    }

}
