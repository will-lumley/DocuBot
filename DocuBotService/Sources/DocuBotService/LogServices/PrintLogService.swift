//
//  PrintLogService.swift
//  
//
//  Created by William Lumley on 25/9/2023.
//

import Foundation

/// A simple implementation of the `LogService` protocol that logs messages to the console.
///
/// The `PrintLogService` uses `print` to output log messages, making it a lightweight logging solution
/// for debugging and development purposes.
final class PrintLogService: LogService {

    // MARK: - Service

    /// The unique key identifying the log service.
    ///
    /// This key is used to register the `PrintLogService` within a service container.
    static var key: ServiceKey {
        .log
    }

    // MARK: - Lifecycle

    /// Initializes a new instance of `PrintLogService`.
    ///
    /// This initializer performs no additional setup as the service uses basic `print` functionality.
    init() {
        // Intentionally left blank.
    }

    // MARK: - LogService

    /// Logs a message to the console with a specified log type.
    ///
    /// This method uses `print` to output the log message in the format: `[DOCUBOT] <logType> <message>`.
    ///
    /// - Parameters:
    ///   - type: The type or severity of the log message, represented by `LogType`.
    ///   - string: The message to log.
    func log(with type: LogType, _ string: String) {
        // swiftlint:disable:next direct_print
        print("[DOCUBOT] \(type.name) \(string)")
    }

}
