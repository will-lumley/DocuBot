//
//  MockFlagService.swift
//
//
//  Created by William Lumley on 10/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

/// A mock implementation of the `FlagService` protocol for testing purposes.
///
/// The `MockFlagService` provides a configurable feature flag service that simulates the
/// behaviour of a real implementation.
/// It uses `UserDefaults` as the default flag value source and allows testing dynamic feature configurations.
final class MockFlagService: FlagService {

    // MARK: - Service

    /// The unique key identifying the flag service.
    ///
    /// This key is used to register the `MockFlagService` within a service container.
    public static var key: ServiceKey {
        .flag
    }

    // MARK: - Properties

    /// The source of the feature flag values.
    ///
    /// This property uses `UserDefaults` to simulate a persistent data source for feature flags.
    public var source: FlagValueSource

    /// The `FlagPole` containing the application's feature flags.
    ///
    /// This property provides access to the mock feature flags for testing.
    public var appFlags: FlagPole<AppFlags>

    // MARK: - Lifecycle

    /// Creates a new instance of `MockFlagService`.
    ///
    /// The initializer sets up the `FlagPole` using `UserDefaults` as the default flag value source.
    init() {
        self.source = UserDefaults.standard
        self.appFlags = FlagPole(hoist: AppFlags.self, sources: [
            self.source
        ])
    }

}
