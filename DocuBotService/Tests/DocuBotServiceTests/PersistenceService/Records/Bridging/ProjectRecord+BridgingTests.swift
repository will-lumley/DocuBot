//
//  ProjectRecord+Bridging+Tests.swift
//  DocuBotServiceTests
//
//  Created by William Lumley on 15/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
import GRDB
import Testing

struct ProjectBridgingTests {

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
        let path = "/projects/sample"
        let name = "Sample Project"
        let urlBookmarkData = Data("SampleBookmark".utf8)
        let documentationChecksum = "abc123"
        let exampleQuestions = ["What is this?", "How does it work?"]
        let alertStatus = Project.AlertStatus.warning(warning: .isDirty)
        let needsFullResync = true
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Project in the Model layer
        let project = Project(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            documentationCheckSum: documentationChecksum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            needsFullResync: needsFullResync,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Project to the Storage layer
        let record = ProjectRecord(model: project)

        // THEN there is no data loss
        #expect(record.id == project.id)
        #expect(record.path == project.path)
        #expect(record.name == project.name)
        #expect(record.urlBookmarkData == project.urlBookmarkData)
        #expect(record.documentationChecksum == project.documentationChecksum)
        #expect(record.exampleQuestions == project.exampleQuestions)
        #expect(record.alertStatus == .init(model: project.alertStatus))
        #expect(record.needsFullResync == project.needsFullResync)
        #expect(record.createdAt == project.createdAt)
        #expect(record.updatedAt == project.updatedAt)
    }

    @Test("Record to Model Bridging")
    func recordToModelBridging() throws {
        // GIVEN we have sample data
        let id: Int64? = 42
        let path = "/projects/sample"
        let name = "Sample Project"
        let urlBookmarkData = Data("SampleBookmark".utf8)
        let documentationChecksum = "abc123"
        let exampleQuestions = ["What is this?", "How does it work?"]
        let alertStatus = ProjectRecord.AlertStatus.error(error: .firstSync)
        let needsFullResync = true
        let createdAt = Date()
        let updatedAt = Date()

        // WHEN we have a Project in the Storage layer
        let record = ProjectRecord(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            documentationChecksum: documentationChecksum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            needsFullResync: needsFullResync,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        // WHEN we bridge the Project to the Model layer
        let project = Project(record: record)

        // THEN there is no data loss
        #expect(project.id == record.id)
        #expect(project.path == record.path)
        #expect(project.name == record.name)
        #expect(project.urlBookmarkData == record.urlBookmarkData)
        #expect(project.documentationChecksum == record.documentationChecksum)
        #expect(project.exampleQuestions == record.exampleQuestions)
        #expect(project.alertStatus == .init(record: record.alertStatus))
        #expect(project.needsFullResync == record.needsFullResync)
        #expect(project.createdAt == record.createdAt)
        #expect(project.updatedAt == record.updatedAt)
    }

    @Test(
        "Model to Record AlertStatus With Warning Bridging",
        arguments: Project.AlertStatus.WarningState.allCases
    )
    func modelToRecordAlertStatusWithWarningBridging(
        warning: Project.AlertStatus.WarningState
    ) throws {
        // GIVEN we have a Warning in the Model layer
        let model = Project.AlertStatus.warning(warning: warning)

        // WHEN we bridge it to the Storage layer
        let record = ProjectRecord.AlertStatus(model: model)

        // THEN there is no data loss
        let expectedRecord = ProjectRecord.AlertStatus.warning(
            warning: .init(model: warning)
        )
        #expect(record == expectedRecord)
    }

    @Test(
        "Model to Record AlertStatus With Error Bridging",
        arguments: Project.AlertStatus.ErrorState.allCases
    )
    func modelToRecordAlertStatusWithErrorBridging(
        error: Project.AlertStatus.ErrorState
    ) throws {
        // GIVEN we have an Error in the Model layer
        let model = Project.AlertStatus.error(error: error)

        // WHEN we bridge it to the Storage layer
        let record = ProjectRecord.AlertStatus(model: model)

        // THEN there is no data loss
        let expectedRecord = ProjectRecord.AlertStatus.error(
            error: .init(model: error)
        )
        #expect(record == expectedRecord)
    }

    @Test("Model to Record AlertStatus With Error Bridging")
    func modelToRecordAlertStatusWithNoneBridging() throws {
        // GIVEN we have a `None` in the Model layer
        let model = Project.AlertStatus.none

        // WHEN we bridge it to the Storage layer
        let record = ProjectRecord.AlertStatus(model: model)

        // THEN there is no data loss
        #expect(record == .none)
    }

    @Test("Record to Model AlertStatus With Warning Bridging")
    func recordToModelAlertStatusWithWarningBridging() throws {
        // GIVEN we have a Warning in the Storage layer
        let warningRecord = ProjectRecord.AlertStatus.warning(
            warning: .directoryChanged
        )

        // WHEN we bridge it to the Model layer
        let bridgedWarningModel = Project.AlertStatus(record: warningRecord)

        // THEN there is no data loss
        #expect(bridgedWarningModel == .warning(warning: .directoryChanged))
    }

    @Test("Record to Model AlertStatus With Error Bridging")
    func recordToModelAlertStatusWithErrorBridging() throws {
        // GIVEN we have an Error in the Storage layer
        let errorRecord = ProjectRecord.AlertStatus.error(
            error: .firstSync
        )

        // WHEN we bridge it to the Model layer
        let bridgedErrorModel = Project.AlertStatus(record: errorRecord)

        // THEN there is no data loss
        #expect(bridgedErrorModel == .error(error: .firstSync))
    }

    @Test("Record to Model AlertStatus With None Bridging")
    func recordToModelAlertStatusWithNoneBridging() throws {
        // GIVEN we have a `None` in the Storage layer
        let noneRecord = ProjectRecord.AlertStatus.none

        // WHEN we bridge it to the Model layer
        let bridgedNoneModel = Project.AlertStatus(record: noneRecord)

        // THEN there is no data loss
        #expect(bridgedNoneModel == .none)
    }

}
