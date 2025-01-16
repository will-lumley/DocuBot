//
//  ServiceKey.swift
//
//
//  Created by William Lumley on 29/6/2023.
//

import DocuBotModel
import Foundation

public enum ServiceKey: String {

    /// Provides an interface for storing and retrieving feature flags
    case flag

    /// Persists and retrieves data
    case persistenceStore

    /// Provides an interface for storing and retrieving preferences
    case preferenceStore

    /// Logs debugging & diagnostic data
    case log
}
