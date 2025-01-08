//
//  EmptyLogService.swift
//  
//
//  Created by William Lumley on 26/9/2023.
//

import Foundation

/// A no-op implementation of the `LogService` protocol.
///
/// The `EmptyLogService` is a placeholder logging service that does nothing when its logging methods
/// are called.
/// This can be useful in testing or scenarios where logging is intentionally disabled.
final class EmptyLogService: LogService {

    // MARK: - Service

    /// The unique key identifying the log service.
    ///
    /// This key is used to register the `EmptyLogService` within a service container.
    static var key: ServiceKey {
        .log
    }

    // MARK: - Lifecycle

    /// Initializes a new instance of `EmptyLogService`.
    ///
    /// This initializer performs no setup since the service is intentionally blank.
    init() {
        // Intentionally left blank.
    }

    // MARK: - LogService

    /// A no-op implementation of the `log(with:_:)` method.
    ///
    /// This method is intentionally left blank and does not perform any logging.
    ///
    /// - Parameters:
    ///   - type: The type or severity of the log message.
    ///   - string: The message to log.
    func log(with type: LogType, _ string: String) {
        // Intentionally left blank.
    }

}
