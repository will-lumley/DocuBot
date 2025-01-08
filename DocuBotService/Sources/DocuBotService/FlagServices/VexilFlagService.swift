//
//  FlagService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

/// An implementation of the `FlagService` protocol using Vexil for feature flag management.
///
/// The `VexilFlagService` provides a production-ready feature flag service leveraging `FlagPole` for dynamic
/// configuration and control. It uses `UserDefaults` from the app group as the data source for feature flags.
final class VexilFlagService: FlagService {

    // MARK: - Service

    /// The unique key identifying the flag service.
    ///
    /// This key is used to register the `VexilFlagService` within a service container.
    public static var key: ServiceKey {
        .flag
    }

    // MARK: - Properties

    /// The `FlagPole` containing the application's feature flags.
    ///
    /// This property provides access to the application's feature flags, dynamically configured through `FlagPole`.
    public let appFlags: FlagPole<AppFlags>

    /// The source of the feature flag values.
    ///
    /// This property uses `UserDefaults` from the app group as the persistent data source for feature flags.
    public let source: FlagValueSource

    // MARK: - Lifecycle

    /// Creates a new instance of `VexilFlagService`.
    ///
    /// This initializer sets up the `FlagPole` using `UserDefaults` from the app group as the flag value source.
    /// If the app group `UserDefaults` cannot be accessed, the initializer will terminate the application.
    ///
    /// - Precondition: The app group `UserDefaults` must be available for the service to function correctly.
    public init() {
        guard let appGroupUserDefaults = UserDefaults(suiteName: Secrets.BundleIDs.appGroup) else {
            fatalError("Failed to get AppGroup UserDefaults.")
        }

        self.source = appGroupUserDefaults
        self.appFlags = FlagPole(hoist: AppFlags.self, sources: [
            self.source
        ])
    }

}
