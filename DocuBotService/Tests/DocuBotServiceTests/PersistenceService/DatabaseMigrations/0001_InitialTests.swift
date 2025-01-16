//
//  0001_InitialTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import GRDB
import Testing

struct InitialMigrationTests { // swiftlint:disable:this type_body_length

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Identifier")
    func identifier() {
        #expect(Initial().identifier == "0001_Initial")
    }

    @Test("Projects Table Schema")
    func projectsTableSchema() throws {

        // GIVEN we have not completed a migration for the Projects table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("projects")
            #expect(tableExists == false)
        }

        // WHEN we run the `Initial` migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        try dbQueue.read { db in
            // THEN the Projects table exists
            let tableExists = try db.tableExists("projects")
            #expect(tableExists == true)

            // THEN there is the correct amount of columns
            let columns = try db.columns(in: "projects")
            #expect(columns.count == 9)

            // THEN there is an ID column with the correct attributes
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // THEN there is a Path column with the correct attributes
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "path")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // THEN there is a Name column with the correct attributes
            #expect(columns[2].type == "TEXT")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "name")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // THEN there is a Checksum column with the correct attributes
            #expect(columns[3].type == "TEXT")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "documentationChecksum")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == false)

            // THEN there is a Bookmark column with the correct attributes
            #expect(columns[4].type == "BLOB")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "urlBookmarkData")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // THEN there is an ExampleQuestions column with the correct attributes
            #expect(columns[5].type == "BLOB")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "exampleQuestions")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // THEN there is an AlertStatus column with the correct attributes
            #expect(columns[6].type == "BLOB")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "alertStatus")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == true)

            // THEN there is a CreatedAt column with the correct attributes
            #expect(columns[7].type == "DATETIME")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "createdAt")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // THEN there is a UpdatedAt column with the correct attributes
            #expect(columns[8].type == "DATETIME")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "updatedAt")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)
        }
    }

    @Test("Documents Table Schema")
    func documentsTableSchema() throws {

        // GIVEN we have not completed a migration for the Documents table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("documents")
            #expect(tableExists == false)
        }

        // WHEN we run the `Initial` migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        try dbQueue.read { db in
            // THEN the Documents table exists
            let tableExists = try db.tableExists("documents")
            #expect(tableExists == true)

            // THEN there is the correct amount of columns
            let columns = try db.columns(in: "documents")
            #expect(columns.count == 9)

            // THEN there is an ID column with the correct attributes
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // THEN there is an URL column with the correct attributes
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "url")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // THEN there is a Project column with the correct attributes
            #expect(columns[2].type == "INTEGER")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "project")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // THEN there is a FileFormat column with the correct attributes
            #expect(columns[3].type == "BLOB")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "fileFormat")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // THEN there is a conent column with the correct attributes
            #expect(columns[4].type == "TEXT")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "content")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // THEN there is a Checksum column with the correct attributes
            #expect(columns[5].type == "TEXT")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "checksum")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // THEN there is an embeddings column with the correct attributes
            #expect(columns[6].type == "BLOB")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "embeddings")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == false)

            // THEN there is an CreatedAt column with the correct attributes
            #expect(columns[7].type == "DATETIME")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "createdAt")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // THEN there is an UpdatedAt column with the correct attributes
            #expect(columns[8].type == "DATETIME")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "updatedAt")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)
        }
    }

    @Test("Models Table Schema")
    func modelsTableSchema() throws {

        // GIVEN we have not completed a migration for the Models table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("models")
            #expect(tableExists == false)
        }

        // WHEN we run the `Initial` migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        try dbQueue.read { db in
            // THEN the Models table exists
            let tableExists = try db.tableExists("models")
            #expect(tableExists == true)

            // THEN there is the correct amount of columns
            let columns = try db.columns(in: "models")
            #expect(columns.count == 6)

            // THEN there is an ID column with the correct attributes
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // THEN there is a Name column with the correct attributes
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "name")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // THEN there is a Path column with the correct attributes
            #expect(columns[2].type == "TEXT")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "path")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // THEN there is a Size column with the correct attributes
            #expect(columns[3].type == "INTEGER")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "size")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // THEN there is a CreatedAt column with the correct attributes
            #expect(columns[4].type == "DATETIME")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "createdAt")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // THEN there is an UpdatedAt column with the correct attributes
            #expect(columns[5].type == "DATETIME")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "updatedAt")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)
        }
    }

    @Test("Project Settings Table Schema")
    func projectSettingsTableSchema() throws {
        // GIVEN we have not completed a migration for the Settings table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("project-settings")
            #expect(tableExists == false)
        }

        // WHEN we run the `Initial` migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        try dbQueue.read { db in
            // THEN the Documents table exists
            let tableExists = try db.tableExists("project-settings")
            #expect(tableExists == true)

            // THEN there is the correct amount of columns
            let columns = try db.columns(in: "project-settings")
            #expect(columns.count == 19)

            // THEN there is an ID column with the correct attributes
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // THEN there is a Project column with the correct attributes
            #expect(columns[1].type == "INTEGER")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "project")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // THEN there is a Model column with the correct attributes
            #expect(columns[2].type == "INTEGER")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "model")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // THEN there is a SupportedFormats column with the correct attributes
            #expect(columns[3].type == "BLOB")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "supportedFormats")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // THEN there is a StrictMode column with the correct attributes
            #expect(columns[4].type == "BOOLEAN")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "strictMode")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // THEN there is a Language column with the correct attributes
            #expect(columns[5].type == "TEXT")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "language")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // THEN there is a SystemPrompt column with the correct attributes
            #expect(columns[6].type == "TEXT")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "systemPrompt")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == true)

            // THEN there is an EmbeddingModel column with the correct attributes
            #expect(columns[7].type == "BLOB")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "embeddingModel")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // THEN there is a SimilarityMetric column with the correct attributes
            #expect(columns[8].type == "BLOB")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "similarityMetric")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)

            // THEN there is a Seed column with the correct attributes
            #expect(columns[9].type == "INTEGER")
            #expect(columns[9].primaryKeyIndex == 0)
            #expect(columns[9].name == "seed")
            #expect(columns[9].defaultValueSQL == nil)
            #expect(columns[9].isNotNull == true)

            // THEN there is a TopK column with the correct attributes
            #expect(columns[10].type == "INTEGER")
            #expect(columns[10].primaryKeyIndex == 0)
            #expect(columns[10].name == "topK")
            #expect(columns[10].defaultValueSQL == nil)
            #expect(columns[10].isNotNull == true)

            // THEN there is a TopP column with the correct attributes
            #expect(columns[11].type == "DOUBLE")
            #expect(columns[11].primaryKeyIndex == 0)
            #expect(columns[11].name == "topP")
            #expect(columns[11].defaultValueSQL == nil)
            #expect(columns[11].isNotNull == true)

            // THEN there is a Temperature column with the correct attributes
            #expect(columns[12].type == "DOUBLE")
            #expect(columns[12].primaryKeyIndex == 0)
            #expect(columns[12].name == "temperature")
            #expect(columns[12].defaultValueSQL == nil)
            #expect(columns[12].isNotNull == true)

            // THEN there is a StopSequence column with the correct attributes
            #expect(columns[13].type == "TEXT")
            #expect(columns[13].primaryKeyIndex == 0)
            #expect(columns[13].name == "stopSequence")
            #expect(columns[13].defaultValueSQL == nil)
            #expect(columns[13].isNotNull == false)

            // THEN there is a MaxTokenCount column with the correct attributes
            #expect(columns[14].type == "INTEGER")
            #expect(columns[14].primaryKeyIndex == 0)
            #expect(columns[14].name == "maxTokenCount")
            #expect(columns[14].defaultValueSQL == nil)
            #expect(columns[14].isNotNull == true)

            // THEN there is a CreatedAt column with the correct attributes
            #expect(columns[15].type == "DATETIME")
            #expect(columns[15].primaryKeyIndex == 0)
            #expect(columns[15].name == "createdAt")
            #expect(columns[15].defaultValueSQL == nil)
            #expect(columns[15].isNotNull == true)

            // THEN there is an UpdatedAt column with the correct attributes
            #expect(columns[16].type == "DATETIME")
            #expect(columns[16].primaryKeyIndex == 0)
            #expect(columns[16].name == "updatedAt")
            #expect(columns[16].defaultValueSQL == nil)
            #expect(columns[16].isNotNull == true)
        }
    }

}
