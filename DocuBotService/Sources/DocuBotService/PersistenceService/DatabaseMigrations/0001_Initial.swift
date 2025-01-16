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
            table.column("urlBookmarkData", .blob)
            table.column("urlBookmarkDataIsStale", .boolean)
                .defaults(to: false)
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
            table.column("respondWithDocumentsOnly", .boolean)
                .notNull()
            table.column("language", .text)
                .notNull()
            table.column("createdAt", .datetime)
                .notNull()
            table.column("updatedAt", .datetime)
                .notNull()
        }

        // Create chats table
        try db.create(table: "chats") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("name", .text)
                .notNull()
            table.column("nameType", .blob)
                .notNull()
            table.column("project", .integer)
                .notNull()
                .references("projects", onDelete: .cascade)
            table.column("createdAt", .datetime)
                .notNull()
        }

        // Create messages table
        try db.create(table: "messages") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("content", .text)
                .notNull()
            table.column("author", .blob)
                .notNull()
            table.column("chat", .integer)
                .notNull()
                .references("chats", onDelete: .cascade)
            table.column("createdAt", .datetime)
                .notNull()
        }
    }

}
