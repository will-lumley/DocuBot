//
//  LogType.swift
//
//
//  Created by William Lumley on 25/9/2023.
//

import Foundation

public enum LogType {
    case info
    case error
}

// MARK: - Public

public extension LogType {

    var name: String {
        switch self {
        case .info:
            return L10n.Log.LogType.info
        case .error:
            return L10n.Log.LogType.error
        }
    }

}
