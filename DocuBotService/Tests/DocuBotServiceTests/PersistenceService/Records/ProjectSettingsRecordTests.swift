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
        // Run the migrations
        let migrations = Index.migrations
        try dbQueue.write { db in
            for migration in migrations {
                try migration.perform(db: db)
            }
        }

        // Prepare sample data
        let projectID: Int64 = 1
        let modelID: Int64 = 1
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

        // Insert an LLMModelRecord
        var model = LLMModelRecord(
            id: nil,
            name: "name",
            path: "path",
            size: 1,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // Insert a ProjectRecord
        var project = ProjectRecord(
            id: nil,
            path: "path",
            name: "name",
            urlBookmarkData: Data(),
            documentationChecksum: "documentationChecksum",
            exampleQuestions: ["example"],
            alertStatus: .none,
            needsFullResync: true,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // Insert a ProjectSettingsRecord
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

        try dbQueue.write { db in
            try model.insert(db)
            try project.insert(db)
            try projectSettings.insert(db)
        }

        // Verify that the record was inserted and fetched correctly
        try dbQueue.read { db in
            let fetchedSettings = try #require(
                try ProjectSettingsRecord.fetchOne(db)
            )

            // A new ID has been assigned
            let newID = try #require(fetchedSettings.id)
            #expect(newID == 1)
            #expect(fetchedSettings.project == projectID)
            #expect(fetchedSettings.model == modelID)
            #expect(fetchedSettings.supportedFormats == supportedFormats)
            #expect(fetchedSettings.language == language)
            #expect(fetchedSettings.embeddingModel == embeddingModel)
            #expect(fetchedSettings.similarityMetric == similarityMetric)
            #expect(fetchedSettings.seed == seed)
            #expect(fetchedSettings.topK == topK)
            #expect(fetchedSettings.topP == topP)
            #expect(fetchedSettings.contextLength == contextLength)
            #expect(fetchedSettings.temperature == temperature)
            #expect(fetchedSettings.batchSize == batchSize)
            #expect(fetchedSettings.stopSequence == stopSequence)
            #expect(fetchedSettings.maxTokenCount == maxTokenCount)
            #expect(fetchedSettings.systemPrompt == systemPrompt)
            #expect(fetchedSettings.strictMode == strictMode)
            #expect(Int(fetchedSettings.createdAt.timeIntervalSince1970) == Int(createdAt.timeIntervalSince1970))
            #expect(Int(fetchedSettings.updatedAt.timeIntervalSince1970) == Int(updatedAt.timeIntervalSince1970))
        }
    }

    @Test("ID Setting")
    func idSetting() throws {
        var projectSettings = ProjectSettingsRecord(
            id: nil,
            project: 1,
            model: 2,
            supportedFormats: [.rtf, .txt],
            language: .english,
            embeddingModel: .multiQaMiniLm,
            similarityMetric: .dotProduct,
            seed: 67890,
            topK: 20,
            topP: 0.8,
            contextLength: 256,
            temperature: 0.5,
            batchSize: 32,
            stopSequence: nil,
            maxTokenCount: 512,
            systemPrompt: "Analyze the document.",
            strictMode: false,
            createdAt: Date(),
            updatedAt: Date()
        )

        // Simulate the didInsert behaviour
        projectSettings.didInsert(
            InsertionSuccess(rowID: 42, persistenceContainer: .init())
        )
        #expect(projectSettings.id == 42)
    }
}
