//
//  LLMModelRecord+Bridging+Tests.swift
//  DocuBotServiceTests
//
//  Created by William Lumley on 15/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
import GRDB
import Testing

struct LLMModelBridgingTests {

    // MARK: - Properties

    private let dbQueue: DatabaseQueue

    // MARK: - Lifecycle

    init() throws {
        self.dbQueue = try DatabaseQueue()
    }

    // MARK: - Tests

    @Test("Model to Record Bridging")
    func modelToRecordBridging() throws {
        // GIVEN we have sample data
        let id: Int64? = 42
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Model in the Model layer
        let model = LLMModel(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Model to the Storage layer
        let record = LLMModelRecord(model: model)

        // THEN there is no data loss
        #expect(record.id == model.id)
        #expect(record.name == model.name)
        #expect(record.path == model.path)
        #expect(record.size == model.size)
        #expect(record.createdAt == model.createdAt)
        #expect(record.updatedAt == model.updatedAt)
    }

    @Test("Record to Model Bridging")
    func recordToModelBridging() throws {
        // GIVEN we have sample data
        let id: Int64? = 42
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Model in the Storage layer
        let record = LLMModelRecord(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Model to the Model layer
        let model = LLMModel(record: record)

        // THEN there is no data losss
        #expect(model.id == record.id)
        #expect(model.name == record.name)
        #expect(model.path == record.path)
        #expect(model.size == record.size)
        #expect(model.createdAt == record.createdAt)
        #expect(model.updatedAt == record.updatedAt)
    }

}
