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
            table.column("createdAt", .datetime)
                .notNull()
        }

        // Create chats table
        try db.create(table: "chats") { table in
            table.column("id", .integer)
                .unique()
                .primaryKey(autoincrement: true)
            table.column("name", .text)
                .notNull()
            table.column("project", .integer)
                .notNull()
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
            table.column("createdAt", .datetime)
                .notNull()
        }
    }

}
