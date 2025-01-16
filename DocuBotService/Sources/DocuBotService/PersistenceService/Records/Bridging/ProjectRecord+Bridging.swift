//
//  ProjectRecord+Bridging.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import DocuBotModel
import Foundation

// MARK: - Record

public extension ProjectRecord {

    init(model: Project) {
        self.init(
            id: model.id,
            path: model.path,
            name: model.name,
            urlBookmarkData: model.urlBookmarkData,
            documentationChecksum: model.documentationChecksum,
            exampleQuestions: model.exampleQuestions,
            alertStatus: .init(model: model.alertStatus),
            needsFullResync: model.needsFullResync,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

private extension ProjectRecord.AlertStatus {

    init(model: Project.AlertStatus) {
        switch model {
        case .none:
            self = .none
        case .warning(let warning):
            self = .warning(warning: .init(model: warning))
        case .error(let error):
            self = .error(error: .init(model: error))
        }
    }

}

private extension ProjectRecord.AlertStatus.WarningState {

    init(model: Project.AlertStatus.WarningState) {
        switch model {
        case .directoryChanged:
            self = .directoryChanged
        case .isDirty:
            self = .isDirty
        case .metricChanged:
            self = .metricChanged
        case .modelChanged:
            self = .modelChanged
        case .formatsChanged:
            self = .formatsChanged
        }
    }

}

private extension ProjectRecord.AlertStatus.ErrorState {

    init(model: Project.AlertStatus.ErrorState) {
        switch model {
        case .firstSync:
            self = .firstSync
        }
    }

}

// MARK: - Model

public extension Project {

    init(record: ProjectRecord) {
        self.init(
            id: record.id,
            path: record.path,
            name: record.name,
            urlBookmarkData: record.urlBookmarkData,
            documentationCheckSum: record.documentationChecksum,
            exampleQuestions: record.exampleQuestions,
            alertStatus: .init(record: record.alertStatus),
            needsFullResync: record.needsFullResync,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}

private extension Project.AlertStatus {

    init(record: ProjectRecord.AlertStatus) {
        switch record {
        case .none:
            self = .none
        case .warning(let warning):
            self = .warning(warning: .init(record: warning))
        case .error(let error):
            self = .error(error: .init(record: error))
        }
    }

}

private extension Project.AlertStatus.WarningState {

    init(record: ProjectRecord.AlertStatus.WarningState) {
        switch record {
        case .directoryChanged:
            self = .directoryChanged
        case .isDirty:
            self = .isDirty
        case .metricChanged:
            self = .metricChanged
        case .modelChanged:
            self = .modelChanged
        case .formatsChanged:
            self = .formatsChanged
        }
    }

}

private extension Project.AlertStatus.ErrorState {

    init(record: ProjectRecord.AlertStatus.ErrorState) {
        switch record {
        case .firstSync:
            self = .firstSync
        }
    }

}
