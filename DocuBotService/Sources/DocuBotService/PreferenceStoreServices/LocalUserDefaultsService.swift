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
        case finishedOnboarding
    }

    // MARK: - Service

    static var key: ServiceKey {
        .preferenceStore
    }

    // MARK: - UserConfigurationService

    var finishedOnboarding: Bool {
        get {
            self.bool(for: .finishedOnboarding)
        }
        set {
            self.set(value: newValue, for: .finishedOnboarding)
        }
    }

}

// MARK: - UserDefaults

private extension LocalUserDefaultsService {

    func set(value: Any?, for key: LocalUserDefaultsService.Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    func bool(for key: LocalUserDefaultsService.Key) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}
