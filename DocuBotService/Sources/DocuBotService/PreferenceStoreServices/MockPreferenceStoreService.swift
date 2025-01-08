//
//  MockPreferenceStoreService.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

/// A mock implementation of the `PreferenceStoreService` protocol.
///
/// This class is used for testing purposes, providing a configurable and predictable
/// implementation of `PreferenceStoreService` without interacting with real user data.
public class MockPreferenceStoreService: PreferenceStoreService {

    // MARK: - Service

    /// The unique key identifying the preference store service.
    ///
    /// This property registers the mock service under the `.preferenceStore` key.
    public static var key: ServiceKey {
        .preferenceStore
    }

    // MARK: - Properties

    /// A mock value indicating whether the app has been launched previously.
    public var launchedPreviously: Bool

    /// A mock value for the number of example questions displayed to the user.
    public var numberOfExampleQuestions: Int

    /// A mock value indicating whether similarity scoring is displayed.
    public var displaySimilarityScoring: Bool

    /// A mock value for the number of characters considered for prefix matching in document processing.
    public var documentPrefixCount: Int

    /// A mock value for the minimum similarity score required to consider a match valid.
    public var similarityFloorScore: Double

    // MARK: - Lifecycle

    /// Creates a new instance of `MockPreferenceStoreService` with default mock values.
    ///
    /// - Default Values:
    ///   - `launchedPreviously`: `false`
    ///   - `numberOfExampleQuestions`: `10`
    ///   - `displaySimilarityScoring`: `true`
    ///   - `documentPrefixCount`: `3`
    ///   - `similarityFloorScore`: `75`
    public init() {
        self.launchedPreviously = false
        self.numberOfExampleQuestions = 10
        self.displaySimilarityScoring = true
        self.documentPrefixCount = 3
        self.similarityFloorScore = 75
    }

}
