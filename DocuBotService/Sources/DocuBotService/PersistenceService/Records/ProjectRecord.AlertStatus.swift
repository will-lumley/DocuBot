//
//  ProjectRecord.AlertStatus.swift
//  DocuBotService
//
//  Created by William Lumley on 29/10/2024.
//

public extension ProjectRecord {

    enum AlertStatus: Hashable, Codable, Sendable {

        public enum WarningState: Hashable, Codable, Sendable {
            case isDirty
            case metricChanged
            case modelChanged
            case formatsChanged
            case directoryChanged
        }

        public enum ErrorState: Hashable, Codable, Sendable {
            case firstSync
        }

        case none
        case warning(warning: WarningState)
        case error(error: ErrorState)
    }

}
