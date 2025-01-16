//
//  ProjectSettingsRecordTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

//
//  ProjectSettingsRecord+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 15/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
@testable import GRDB
import Testing

struct ProjectSettingsRecordTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Database Table Name")
    func databaseTableName() {
        #expect(ProjectSettingsRecord.databaseTableName == "project-settings")
    }

    @Test("Insert and Fetch")
    func insertAndFetch() throws {
        // GIVEN we have our DB migrations
        let migrations = Index.migrations

        // GIVEN we perform our migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // GIVEN we have sample data
        let projectID = Int64(1)
        let modelID = Int64(1)
        let supportedFormats: [ProjectSettingsRecord.DocumentationFormat] = [.rtf, .md]
        let language = ProjectSettingsRecord.Language.english
        let embeddingModel = ProjectSettingsRecord.EmbeddingModel.miniLmAll
        let similarityMetric = ProjectSettingsRecord.SimilarityMetric.cosine
        let seed = 12345
        let topK = 10
        let topP = 0.9
        let contextLength = 512
        let temperature = 0.7
        let batchSize = 16
        let stopSequence = "###"
        let maxTokenCount = 1024
        let systemPrompt = "Please summarize the document."
        let strictMode = true
        let createdAt = Date()
        let updatedAt = Date()

        // GIVEN we have an LLMModelRecord to commit
        var model = LLMModelRecord(model: .mock())

        // GIVEN we have a ProjectRecord to commit
        var project = ProjectRecord(model: .mock())

        // GIVEN we have our ProjectSettings to commit, with our sample data
        var projectSettings = ProjectSettingsRecord(
            id: nil,
            project: projectID,
            model: modelID,
            supportedFormats: supportedFormats,
            language: language,
            embeddingModel: embeddingModel,
            similarityMetric: similarityMetric,
            seed: seed,
            topK: topK,
            topP: topP,
            contextLength: contextLength,
            temperature: temperature,
            batchSize: batchSize,
            stopSequence: stopSequence,
            maxTokenCount: maxTokenCount,
            systemPrompt: systemPrompt,
            strictMode: strictMode,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we commit the records to the DB
        try dbQueue.write { db in
            try model.insert(db)
            try project.insert(db)
            try projectSettings.insert(db)
        }

        try dbQueue.read { db in
            // THEN we fetch our ProjectSettings
            let fetchedSettings = try #require(
                try ProjectSettingsRecord.fetchOne(db)
            )

            // THEN our ProjectSettings has been given an ID
            let newID = try #require(fetchedSettings.id)
            #expect(newID == 1)

            // THEN our FetchedProjectSettings has the correct data filled out
            let fetchedSettingsModel = ProjectSettings(record: fetchedSettings)
            let projectSettingsModel = ProjectSettings(record: projectSettings)
            #expect(fetchedSettingsModel.isEqualToIgnoringID(projectSettingsModel))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        // GIVEN we have a ProjectSettingsRecord with no existing ID
        var testSubject = ProjectSettingsRecord(model: .mock())

        // WHEN we insert this ProjectSettings into the DB
        // and SQLite gives it an ID of 42
        testSubject.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )

        // THEN we have been given the ID of 42
        #expect(testSubject.id == 42)
    }
}
