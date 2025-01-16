//
//  Initial.swift
//
//
//  Created by William Lumley on 18/6/2024.
//

import GRDB

/// A database migration that defines the initial schema for the application.
///
/// The `Initial` migration creates the foundational tables required for the application, including
/// `projects`, `documents`, `models`, and `project-settings`. This is the first migration
///  in the database migration history.
struct Initial: DatabaseMigration {

    /// The unique identifier for the migration.
    ///
    /// This identifier ensures that the migration is tracked and applied in the correct order.
    var identifier: String {
        "0001_Initial"
    }

    /// Performs the migration by creating the necessary tables in the database.
    ///
    /// This method defines the schema for the `projects`, `documents`, `models`,
    /// and `project-settings` tables,
    /// setting up their columns, data types, constraints, and relationships.
    ///
    /// - Parameter db: The database instance on which the migration is performed.
    /// - Throws: An error if the table creation or any schema change fails.
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
                .references("projects", onDelete: .cascade)
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

        // Create models table
        try db.create(table: "models") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("name", .text)
                .notNull()
            table.column("path", .text)
                .notNull()
            table.column("size", .integer)
                .notNull()
            table.column("createdAt", .datetime)
                .notNull()
            table.column("updatedAt", .datetime)
                .notNull()
        }

        // Create project-settings table
        try db.create(table: "project-settings") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("project", .integer)
                .notNull()
                .references("projects", onDelete: .cascade)
            table.column("model", .integer)
                .notNull()
                .references("models", onDelete: .cascade)
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
            table.column("temperature", .double)
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
