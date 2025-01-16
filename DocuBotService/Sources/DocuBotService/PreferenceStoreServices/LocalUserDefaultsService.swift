//
//  LocalUserDefaultsService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation

class LocalUserDefaultsService: PreferenceStoreService {

    // MARK: - Types

    enum Key: String {
        case launchedPreviously

        // General Settings
        case numberOfExampleQuestions
        case displaySimilarityScoring

        // Document Embedding Settings
        case documentPrefixCount
        case similarityFloorScore
    }

    // MARK: - Service

    static var key: ServiceKey {
        .preferenceStore
    }

    // MARK: - Lifecycle

    init() {
        // If this is our first launch, set the default values
        if self.launchedPreviously == false {
            self.launchedPreviously = true
            self.numberOfExampleQuestions = 10
            self.displaySimilarityScoring = false
            self.documentPrefixCount = 3
            self.similarityFloorScore = 80
        }
    }

    // MARK: - UserConfigurationService

    var launchedPreviously: Bool {
        get { self.bool(for: .launchedPreviously) }
        set { self.set(value: newValue, for: .launchedPreviously) }
    }

    var numberOfExampleQuestions: Int {
        get { self.int(for: .numberOfExampleQuestions) }
        set { self.set(value: newValue, for: .numberOfExampleQuestions) }
    }

    var displaySimilarityScoring: Bool {
        get { self.bool(for: .displaySimilarityScoring) }
        set { self.set(value: newValue, for: .displaySimilarityScoring) }
    }

    var documentPrefixCount: Int {
        get { self.int(for: .documentPrefixCount) }
        set { self.set(value: newValue, for: .documentPrefixCount) }
    }

    var similarityFloorScore: Double {
        get { self.double(for: .similarityFloorScore) }
        set { self.set(value: newValue, for: .similarityFloorScore) }
    }

}

// MARK: - Private

private extension LocalUserDefaultsService {

    func set(value: Any?, for key: LocalUserDefaultsService.Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    func bool(for key: LocalUserDefaultsService.Key) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }

    func int(for key: LocalUserDefaultsService.Key) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }

    func double(for key: LocalUserDefaultsService.Key) -> Double {
        UserDefaults.standard.double(forKey: key.rawValue)
    }

}
