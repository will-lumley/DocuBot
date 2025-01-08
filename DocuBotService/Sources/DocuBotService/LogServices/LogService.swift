//
//  LogService.swift
//
//
//  Created by William Lumley on 1/7/2023.
//

import Foundation

/// A protocol defining the requirements for a logging service.
///
/// Conforming types provide functionality to log messages with different levels of severity
/// or importance throughout the application.
public protocol LogService: Service {

    /// Logs a message with a specified log type.
    ///
    /// This method allows developers to log diagnostic, informational, or error messages
    /// to assist with debugging and monitoring application behavior.
    ///
    /// - Parameters:
    ///   - type: The type or severity of the log message, represented by the `LogType` enum.
    ///   - string: The message to log.
    func log(with type: LogType, _ string: String)

}
