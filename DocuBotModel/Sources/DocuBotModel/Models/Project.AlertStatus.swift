//
//  Project.AlertStatus.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

public extension Project {

    enum AlertStatus: Hashable, Codable, Sendable {

        public enum WarningState: Int, Hashable, Codable, Sendable {
            case isDirty              = 1
            case metricChanged        = 2
            case modelChanged         = 5
            case formatsChanged       = 6
            case directoryChanged     = 7
        }

        public enum ErrorState: Int, Hashable, Codable, Sendable {
            case firstSync            = 101
        }

        case none
        case warning(warning: WarningState)
        case error(error: ErrorState)
    }

}

// MARK: - Public

public extension Project.AlertStatus {

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

    var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }

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

}
