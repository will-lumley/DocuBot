//
//  AppFlags.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation
import Vexil

/// A container for the application's feature flags.
///
/// The `AppFlags` struct organizes feature flags into groups, providing a structured and centralized way
/// to manage and access application-wide flags.
public struct AppFlags: FlagContainer {

    // MARK: - Flags

    /// Flags controlling the persistence service.
    ///
    /// This group contains feature flags that influence the behaviour of the persistence layer.
    @FlagGroup(description: "Flags controlling the Persistence Service")
    public var database: DatabaseFlags

    /// Flags controlling which services will be leveraged.
    ///
    /// This group contains feature flags that determine which services are active and how they are used.
    @FlagGroup(description: "Flags controlling which services will be leveraged")
    public var services: ServiceFlags

    // MARK: - Lifecycle

    /// Creates a new instance of `AppFlags`.
    ///
    /// The initializer sets up the feature flag groups but performs no additional configuration.
    public init() {
        // Intentionally left blank
    }

}
