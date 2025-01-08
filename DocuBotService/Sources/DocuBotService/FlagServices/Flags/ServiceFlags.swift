//
//  ServiceFlags.swift
//  
//
//  Created by William Lumley on 13/7/2023.
//

import Vexil

/// A container for feature flags controlling the services used in the application.
///
/// The `ServiceFlags` struct defines feature flags that determine which services are active and how they behave.
public struct ServiceFlags: FlagContainer {

    // MARK: - Types

    /// Enum representing the available log service options.
    ///
    /// This enum defines the types of log services that can be configured via feature flags.
    public enum LogService: String, CaseIterable, FlagValue {
        /// A no-op log service that performs no logging.
        case empty

        /// A log service that prints log messages to the console.
        case print
    }

    // MARK: - Flags

    /// The log service to be used in the application.
    ///
    /// This flag determines which implementation of the log service will be active. The default value is `.empty`.
    @Flag(default: LogService.empty, description: "The Log service that we will use")
    public var logService: LogService

    // MARK: - Lifecycle

    /// Creates a new instance of `ServiceFlags`.
    ///
    /// The initializer sets up the flags with their default values.
    public init() {
        // Intentionally left blank
    }

}
