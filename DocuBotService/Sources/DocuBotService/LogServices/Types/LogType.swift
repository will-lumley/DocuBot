//
//  LogType.swift
//
//
//  Created by William Lumley on 25/9/2023.
//

import Foundation

/// Represents the type or severity of a log message.
///
/// The `LogType` enum categorises log messages into distinct types, such as informational or error logs.
public enum LogType {
    /// Informational messages that provide insights into the application's normal operations.
    case info

    /// Error messages that indicate issues or failures in the application.
    case error
}

// MARK: - Public

public extension LogType {

    /// A human-readable name for the log type.
    ///
    /// This property returns a localized string that describes the log type.
    ///
    /// - Returns:
    ///   - `"Info"` for informational messages.
    ///   - `"Error"` for error messages.
    var name: String {
        switch self {
        case .info:
            return L10n.Log.LogType.info
        case .error:
            return L10n.Log.LogType.error
        }
    }

}
