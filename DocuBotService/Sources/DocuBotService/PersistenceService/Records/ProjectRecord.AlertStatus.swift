//
//  ProjectRecord.AlertStatus.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

/// An extension of `ProjectRecord` that defines alert statuses for project-related warnings and errors.
public extension ProjectRecord {

    /// Represents the alert status of a project.
    ///
    /// The `AlertStatus` enum categorises different states of alerts, including warnings and errors,
    /// providing detailed information about the project's current status.
    enum AlertStatus: Hashable, Codable, Sendable {

        /// Represents warning states for a project.
        ///
        /// Warning states indicate non-critical issues that may require user attention.
        public enum WarningState: Hashable, Codable, Sendable {
            /// Indicates that the project has unsaved changes.
            case isDirty

            /// Indicates that the similarity metric used in the project has been modified.
            case metricChanged

            /// Indicates that the embedding model used in the project has been changed.
            case modelChanged

            /// Indicates that the supported formats for the project have been altered.
            case formatsChanged

            /// Indicates that the project's directory has been changed.
            case directoryChanged
        }

        /// Represents error states for a project.
        ///
        /// Error states indicate critical issues that must be resolved to ensure correct functionality.
        public enum ErrorState: Hashable, Codable, Sendable {
            /// Indicates that the project's first sync has failed.
            case firstSync
        }

        /// No alerts are currently present.
        case none

        /// A warning state is active for the project.
        ///
        /// - Parameter warning: The specific warning state.
        case warning(warning: WarningState)

        /// An error state is active for the project.
        ///
        /// - Parameter error: The specific error state.
        case error(error: ErrorState)
    }

}
