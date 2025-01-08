//
//  LocalUserDefaultsService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation

/// A concrete implementation of `PreferenceStoreService` that stores user preferences in `UserDefaults`.
///
/// The `LocalUserDefaultsService` provides a persistent storage mechanism for user-specific settings,
/// leveraging `UserDefaults` to manage preferences across app launches.
final class LocalUserDefaultsService: PreferenceStoreService {

    // MARK: - Types

    /// Keys used to identify user preference values in `UserDefaults`.
    enum Key: String {
        /// Indicates whether the app has been launched previously.
        case launchedPreviously

        // General Settings
        /// The number of example questions displayed to the user.
        case numberOfExampleQuestions
        /// Indicates whether similarity scoring should be displayed in the app interface.
        case displaySimilarityScoring

        // Document Embedding Settings
        /// The number of characters used for prefix matching in document processing.
        case documentPrefixCount
        /// The minimum similarity score required to consider a match valid.
        case similarityFloorScore
    }

    // MARK: - Service

    /// The unique key identifying the preference store service.
    ///
    /// This property registers the service under the `.preferenceStore` key.
    static var key: ServiceKey {
        .preferenceStore
    }

    // MARK: - Lifecycle

    /// Creates a new instance of `LocalUserDefaultsService`.
    ///
    /// During initialization, default values are set if the app is launching for the first time.
    init() {
        if self.launchedPreviously == false {
            self.launchedPreviously = true
            self.numberOfExampleQuestions = 10
            self.displaySimilarityScoring = false
            self.documentPrefixCount = 3
            self.similarityFloorScore = 80
        }
    }

    // MARK: - UserConfigurationService

    /// Indicates whether the app has been launched previously.
    var launchedPreviously: Bool {
        get { self.bool(for: .launchedPreviously) }
        set { self.set(value: newValue, for: .launchedPreviously) }
    }

    /// The number of example questions displayed to the user.
    var numberOfExampleQuestions: Int {
        get { self.int(for: .numberOfExampleQuestions) }
        set { self.set(value: newValue, for: .numberOfExampleQuestions) }
    }

    /// Indicates whether similarity scoring should be displayed in the app interface.
    var displaySimilarityScoring: Bool {
        get { self.bool(for: .displaySimilarityScoring) }
        set { self.set(value: newValue, for: .displaySimilarityScoring) }
    }

    /// The number of characters used for prefix matching in document processing.
    var documentPrefixCount: Int {
        get { self.int(for: .documentPrefixCount) }
        set { self.set(value: newValue, for: .documentPrefixCount) }
    }

    /// The minimum similarity score required to consider a match valid.
    var similarityFloorScore: Double {
        get { self.double(for: .similarityFloorScore) }
        set { self.set(value: newValue, for: .similarityFloorScore) }
    }

}

// MARK: - Private

private extension LocalUserDefaultsService {

    /// Sets a value in `UserDefaults` for a given key.
    ///
    /// - Parameters:
    ///   - value: The value to set.
    ///   - key: The key under which the value is stored.
    func set(value: Any?, for key: LocalUserDefaultsService.Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    /// Retrieves a Boolean value from `UserDefaults` for a given key.
    ///
    /// - Parameter key: The key associated with the value.
    /// - Returns: The Boolean value stored for the key, or `false` if none exists.
    func bool(for key: LocalUserDefaultsService.Key) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }

    /// Retrieves an integer value from `UserDefaults` for a given key.
    ///
    /// - Parameter key: The key associated with the value.
    /// - Returns: The integer value stored for the key, or `0` if none exists.
    func int(for key: LocalUserDefaultsService.Key) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }

    /// Retrieves a double value from `UserDefaults` for a given key.
    ///
    /// - Parameter key: The key associated with the value.
    /// - Returns: The double value stored for the key, or `0.0` if none exists.
    func double(for key: LocalUserDefaultsService.Key) -> Double {
        UserDefaults.standard.double(forKey: key.rawValue)
    }
}
