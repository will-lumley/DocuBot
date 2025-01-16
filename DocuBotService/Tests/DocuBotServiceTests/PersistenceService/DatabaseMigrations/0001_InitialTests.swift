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

        // Before the migration, there is no projects table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("projects")
            #expect(tableExists == false)
        }

        // Run the migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        // Read the database
        try dbQueue.read { db in
            // The projects table now exists
            let tableExists = try db.tableExists("projects")
            #expect(tableExists == true)

            let columns = try db.columns(in: "projects")
            #expect(columns.count == 10)

            // Check the ID column
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // Check the Path column
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "path")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // Check the Name column
            #expect(columns[2].type == "TEXT")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "name")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // Check the DocumentationChecksum column
            #expect(columns[3].type == "TEXT")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "documentationChecksum")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == false)

            // Check the UrlBookmarkData column
            #expect(columns[4].type == "BLOB")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "urlBookmarkData")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // Check the ExampleQuestions column
            #expect(columns[5].type == "BLOB")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "exampleQuestions")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // Check the AlertStatus column
            #expect(columns[6].type == "BLOB")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "alertStatus")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == true)

            // Check the NeedsFullResync column
            #expect(columns[7].type == "BOOLEAN")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "needsFullResync")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // Check the CreatedAt column
            #expect(columns[8].type == "DATETIME")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "createdAt")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)

            // Check the UpdatedAt column
            #expect(columns[9].type == "DATETIME")
            #expect(columns[9].primaryKeyIndex == 0)
            #expect(columns[9].name == "updatedAt")
            #expect(columns[9].defaultValueSQL == nil)
            #expect(columns[9].isNotNull == true)
        }
    }

    @Test("Documents Table Schema")
    func documentsTableSchema() throws {

        // Before the migration, there is no projects table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("documents")
            #expect(tableExists == false)
        }

        // Run the migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        // Read the database
        try dbQueue.read { db in
            // The projects table now exists
            let tableExists = try db.tableExists("documents")
            #expect(tableExists == true)

            let columns = try db.columns(in: "documents")
            #expect(columns.count == 9)

            // Check the ID column
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // Check the URL column
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "url")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // Check the Project column
            #expect(columns[2].type == "INTEGER")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "project")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // Check the FileFormat column
            #expect(columns[3].type == "BLOB")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "fileFormat")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // Check the Content column
            #expect(columns[4].type == "TEXT")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "content")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // Check the Checksum column
            #expect(columns[5].type == "TEXT")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "checksum")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // Check the Embeddings column
            #expect(columns[6].type == "BLOB")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "embeddings")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == false)

            // Check the CreatedAt column
            #expect(columns[7].type == "DATETIME")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "createdAt")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // Check the UpdatedAt column
            #expect(columns[8].type == "DATETIME")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "updatedAt")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)
        }
    }

    @Test("Models Table Schema")
    func modelsTableSchema() throws {

        // Before the migration, there is no models table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("models")
            #expect(tableExists == false)
        }

        // Run the migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        // Read the database
        try dbQueue.read { db in
            // The models table now exists
            let tableExists = try db.tableExists("models")
            #expect(tableExists == true)

            let columns = try db.columns(in: "models")
            #expect(columns.count == 6)

            // Check the ID column
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // Check the Name column
            #expect(columns[1].type == "TEXT")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "name")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // Check the Path column
            #expect(columns[2].type == "TEXT")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "path")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // Check the Size column
            #expect(columns[3].type == "INTEGER")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "size")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // Check the CreatedAt column
            #expect(columns[4].type == "DATETIME")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "createdAt")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // Check the UpdatedAt column
            #expect(columns[5].type == "DATETIME")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "updatedAt")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)
        }
    }

    @Test("Project Settings Table Schema")
    func projectSettingsTableSchema() throws { // swiftlint:disable:this function_body_length

        // Before the migration, there is no project-settings table
        try dbQueue.read { db in
            let tableExists = try db.tableExists("project-settings")
            #expect(tableExists == false)
        }

        // Run the migration
        let migration = Initial()
        try dbQueue.write { db in
            try migration.perform(db: db)
        }

        // Read the database
        try dbQueue.read { db in
            // The project-settings table now exists
            let tableExists = try db.tableExists("project-settings")
            #expect(tableExists == true)

            let columns = try db.columns(in: "project-settings")
            #expect(columns.count == 19)

            // Check the ID column
            #expect(columns[0].type == "INTEGER")
            #expect(columns[0].primaryKeyIndex == 1)
            #expect(columns[0].name == "id")
            #expect(columns[0].defaultValueSQL == nil)
            #expect(columns[0].isNotNull == false)

            // Check the Project column
            #expect(columns[1].type == "INTEGER")
            #expect(columns[1].primaryKeyIndex == 0)
            #expect(columns[1].name == "project")
            #expect(columns[1].defaultValueSQL == nil)
            #expect(columns[1].isNotNull == true)

            // Check the Model column
            #expect(columns[2].type == "INTEGER")
            #expect(columns[2].primaryKeyIndex == 0)
            #expect(columns[2].name == "model")
            #expect(columns[2].defaultValueSQL == nil)
            #expect(columns[2].isNotNull == true)

            // Check the SupportedFormats column
            #expect(columns[3].type == "BLOB")
            #expect(columns[3].primaryKeyIndex == 0)
            #expect(columns[3].name == "supportedFormats")
            #expect(columns[3].defaultValueSQL == nil)
            #expect(columns[3].isNotNull == true)

            // Check the StrictMode column
            #expect(columns[4].type == "BOOLEAN")
            #expect(columns[4].primaryKeyIndex == 0)
            #expect(columns[4].name == "strictMode")
            #expect(columns[4].defaultValueSQL == nil)
            #expect(columns[4].isNotNull == true)

            // Check the Language column
            #expect(columns[5].type == "TEXT")
            #expect(columns[5].primaryKeyIndex == 0)
            #expect(columns[5].name == "language")
            #expect(columns[5].defaultValueSQL == nil)
            #expect(columns[5].isNotNull == true)

            // Check the SystemPrompt column
            #expect(columns[6].type == "TEXT")
            #expect(columns[6].primaryKeyIndex == 0)
            #expect(columns[6].name == "systemPrompt")
            #expect(columns[6].defaultValueSQL == nil)
            #expect(columns[6].isNotNull == true)

            // Check the EmbeddingModel column
            #expect(columns[7].type == "BLOB")
            #expect(columns[7].primaryKeyIndex == 0)
            #expect(columns[7].name == "embeddingModel")
            #expect(columns[7].defaultValueSQL == nil)
            #expect(columns[7].isNotNull == true)

            // Check the SimilarityMetric column
            #expect(columns[8].type == "BLOB")
            #expect(columns[8].primaryKeyIndex == 0)
            #expect(columns[8].name == "similarityMetric")
            #expect(columns[8].defaultValueSQL == nil)
            #expect(columns[8].isNotNull == true)

            // Check the Seed column
            #expect(columns[9].type == "INTEGER")
            #expect(columns[9].primaryKeyIndex == 0)
            #expect(columns[9].name == "seed")
            #expect(columns[9].defaultValueSQL == nil)
            #expect(columns[9].isNotNull == true)

            // Check the TopK column
            #expect(columns[10].type == "INTEGER")
            #expect(columns[10].primaryKeyIndex == 0)
            #expect(columns[10].name == "topK")
            #expect(columns[10].defaultValueSQL == nil)
            #expect(columns[10].isNotNull == true)

            // Check the TopP column
            #expect(columns[11].type == "DOUBLE")
            #expect(columns[11].primaryKeyIndex == 0)
            #expect(columns[11].name == "topP")
            #expect(columns[11].defaultValueSQL == nil)
            #expect(columns[11].isNotNull == true)

            // Check the ContextLength column
            #expect(columns[12].type == "INTEGER")
            #expect(columns[12].primaryKeyIndex == 0)
            #expect(columns[12].name == "contextLength")
            #expect(columns[12].defaultValueSQL == nil)
            #expect(columns[12].isNotNull == true)

            // Check the Temperature column
            #expect(columns[13].type == "DOUBLE")
            #expect(columns[13].primaryKeyIndex == 0)
            #expect(columns[13].name == "temperature")
            #expect(columns[13].defaultValueSQL == nil)
            #expect(columns[13].isNotNull == true)

            // Check the BatchSize column
            #expect(columns[14].type == "INTEGER")
            #expect(columns[14].primaryKeyIndex == 0)
            #expect(columns[14].name == "batchSize")
            #expect(columns[14].defaultValueSQL == nil)
            #expect(columns[14].isNotNull == true)

            // Check the StopSequence column
            #expect(columns[15].type == "TEXT")
            #expect(columns[15].primaryKeyIndex == 0)
            #expect(columns[15].name == "stopSequence")
            #expect(columns[15].defaultValueSQL == nil)
            #expect(columns[15].isNotNull == false)

            // Check the MaxTokenCount column
            #expect(columns[16].type == "INTEGER")
            #expect(columns[16].primaryKeyIndex == 0)
            #expect(columns[16].name == "maxTokenCount")
            #expect(columns[16].defaultValueSQL == nil)
            #expect(columns[16].isNotNull == true)

            // Check the CreatedAt column
            #expect(columns[17].type == "DATETIME")
            #expect(columns[17].primaryKeyIndex == 0)
            #expect(columns[17].name == "createdAt")
            #expect(columns[17].defaultValueSQL == nil)
            #expect(columns[17].isNotNull == true)

            // Check the UpdatedAt column
            #expect(columns[18].type == "DATETIME")
            #expect(columns[18].primaryKeyIndex == 0)
            #expect(columns[18].name == "updatedAt")
            #expect(columns[18].defaultValueSQL == nil)
            #expect(columns[18].isNotNull == true)
        }
    }

}
