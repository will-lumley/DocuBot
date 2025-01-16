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
        // Prepare sample LLMModel data
        let id: Int64? = 42
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        let model = LLMModel(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // Convert to LLMModelRecord
        let record = LLMModelRecord(model: model)

        // Validate record properties
        #expect(record.id == model.id)
        #expect(record.name == model.name)
        #expect(record.path == model.path)
        #expect(record.size == model.size)
        #expect(record.createdAt == model.createdAt)
        #expect(record.updatedAt == model.updatedAt)
    }

    @Test("Record to Model Bridging")
    func recordToModelBridging() throws {
        // Prepare sample LLMModelRecord data
        let id: Int64? = 42
        let name = "GPT-4"
        let path = "/models/gpt-4"
        let size: Int64 = 1024 * 1024 * 1024 // 1 GB
        let createdAt = Date()
        let updatedAt = Date()

        let record = LLMModelRecord(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // Convert to LLMModel
        let model = LLMModel(record: record)

        // Validate model properties
        #expect(model.id == record.id)
        #expect(model.name == record.name)
        #expect(model.path == record.path)
        #expect(model.size == record.size)
        #expect(model.createdAt == record.createdAt)
        #expect(model.updatedAt == record.updatedAt)
    }

}
