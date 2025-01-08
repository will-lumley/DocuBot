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

    /// Initializes a `ProjectRecord` from a `Project` model.
    ///
    /// This initializer converts a `Project` instance into its corresponding `ProjectRecord` representation
    /// for database storage. It maps all relevant properties, including path, name, alert status, and metadata.
    ///
    /// - Parameter model: The `Project` model to convert.
    init(model: Project) {
        self.init(
            id: model.id,
            path: model.path,
            name: model.name,
            urlBookmarkData: model.urlBookmarkData,
            documentationChecksum: model.documentationChecksum,
            exampleQuestions: model.exampleQuestions,
            alertStatus: .init(model: model.alertStatus),
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

}

extension ProjectRecord.AlertStatus {

    /// Initializes a `ProjectRecord.AlertStatus` from a `Project.AlertStatus`.
    ///
    /// This initializer converts a `Project.AlertStatus` into its corresponding database-compatible representation.
    ///
    /// - Parameter model: The `Project.AlertStatus` to convert.
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

extension ProjectRecord.AlertStatus.WarningState {

    /// Initializes a `ProjectRecord.AlertStatus.WarningState` from
    /// a `Project.AlertStatus.WarningState`.
    ///
    /// This initializer maps warning states, such as directory changes or model
    /// updates, into the database-compatible representation.
    ///
    /// - Parameter model: The `Project.AlertStatus.WarningState` to convert.
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

extension ProjectRecord.AlertStatus.ErrorState {

    /// Initializes a `ProjectRecord.AlertStatus.ErrorState` from
    /// a `Project.AlertStatus.ErrorState`.
    ///
    /// - Parameter model: The `Project.AlertStatus.ErrorState` to convert.
    init(model: Project.AlertStatus.ErrorState) {
        switch model {
        case .firstSync:
            self = .firstSync
        }
    }

}

// MARK: - Model

public extension Project {

    /// Initializes a `Project` model from a `ProjectRecord`.
    ///
    /// This initializer converts a `ProjectRecord` instance into its corresponding `Project` model
    /// for use in application logic. It maps all relevant properties, including path, name, alert status, and metadata.
    ///
    /// - Parameter record: The `ProjectRecord` to convert.
    init(record: ProjectRecord) {
        self.init(
            id: record.id,
            path: record.path,
            name: record.name,
            urlBookmarkData: record.urlBookmarkData,
            documentationCheckSum: record.documentationChecksum,
            exampleQuestions: record.exampleQuestions,
            alertStatus: .init(record: record.alertStatus),
            createdAt: record.createdAt,
            updatedAt: record.updatedAt
        )
    }

}

extension Project.AlertStatus {

    /// Initializes a `Project.AlertStatus` from a `ProjectRecord.AlertStatus`.
    ///
    /// This initializer converts a database representation of alert status into an application model.
    ///
    /// - Parameter record: The `ProjectRecord.AlertStatus` to convert.
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

extension Project.AlertStatus.WarningState {

    /// Initializes a `Project.AlertStatus.WarningState` from
    ///  a `ProjectRecord.AlertStatus.WarningState`.
    ///
    /// This initializer maps warning states from the database representation to the application model.
    ///
    /// - Parameter record: The `ProjectRecord.AlertStatus.WarningState` to convert.
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

extension Project.AlertStatus.ErrorState {

    /// Initializes a `Project.AlertStatus.ErrorState` from
    /// a `ProjectRecord.AlertStatus.ErrorState`.
    ///
    /// This initializer maps error states from the database representation to the application model.
    ///
    /// - Parameter record: The `ProjectRecord.AlertStatus.ErrorState` to convert.
    init(record: ProjectRecord.AlertStatus.ErrorState) {
        switch record {
        case .firstSync:
            self = .firstSync
        }
    }

}
