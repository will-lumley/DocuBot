//
//  Project.AlertStatus.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

public extension Project {

    /// Represents the alert status of a project, including warnings and errors.
    ///
    /// The `AlertStatus` enum organizes project alerts into categories and provides metadata for handling them.
    enum AlertStatus: Hashable, Codable, Sendable, Equatable {

        /// Represents various warning states for a project.
        public enum WarningState: Int, Hashable, Codable, Sendable, CaseIterable, Equatable {
            /// Indicates the project is in a "dirty" state.
            case isDirty = 1

            /// Indicates the similarity metric has changed.
            case metricChanged = 2

            /// Indicates the model used by the project has changed.
            case modelChanged = 5

            /// Indicates the supported formats have changed.
            case formatsChanged = 6

            /// Indicates the directory associated with the project has changed.
            case directoryChanged = 7
        }

        /// Represents various error states for a project.
        public enum ErrorState: Int, Hashable, Codable, Sendable, CaseIterable, Equatable {
            /// Indicates the project has not been synchronized yet.
            case firstSync = 101
        }

        /// Indicates no alerts are present.
        case none

        /// Indicates a warning with an associated warning state.
        case warning(warning: WarningState)

        /// Indicates an error with an associated error state.
        case error(error: ErrorState)
    }

}

// MARK: - Public

public extension Project.AlertStatus {

    /// Retrieves the raw integer value associated with the alert status.
    ///
    /// - Returns: An integer representing the warning or error state, or `-1` for `none`.
    var rawValue: Int {
        switch self {
        case .warning(let warning):
            return warning.rawValue
        case .error(let error):
            return error.rawValue
        case .none:
            return -1
        }
    }

    /// Indicates whether the alert status represents an error.
    ///
    /// - Returns: `true` if the alert status is an error, otherwise `false`.
    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }

    /// Indicates whether the alert status represents a "dirty" warning state.
    ///
    /// - Returns: `true` if the alert status is a warning of type `.isDirty`, otherwise `false`.
    var isDirty: Bool {
        switch self {
        case .warning(let warning):
            if case .isDirty = warning {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

    /// Indicates whether the alert status represents a "first synchronization" error state.
    ///
    /// - Returns: `true` if the alert status is an error of type `.firstSync`, otherwise `false`.
    var isFirstSync: Bool {
        switch self {
        case .error(let error):
            if case .firstSync = error {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}
