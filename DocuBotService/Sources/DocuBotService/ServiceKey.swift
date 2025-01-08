//
//  ServiceKey.swift
//
//
//  Created by William Lumley on 29/6/2023.
//

import DocuBotModel
import Foundation

/// A key enumeration representing various services used in the application.
///
/// The `ServiceKey` enum defines identifiers for different services, allowing for a consistent and type-safe
/// way to reference and interact with them.
public enum ServiceKey: String {

    /// A service key for feature flag management.
    ///
    /// This service provides an interface for storing and retrieving feature flags, enabling dynamic feature toggles.
    case flag

    /// A service key for data persistence.
    ///
    /// This service handles the storage and retrieval of data, ensuring it is securely saved and accessible.
    case persistenceStore

    /// A service key for managing user preferences.
    ///
    /// This service provides an interface for storing and retrieving user-specific settings and preferences.
    case preferenceStore

    /// A service key for logging.
    ///
    /// This service logs debugging and diagnostic data to aid in application monitoring and troubleshooting.
    case log

    /// A service key for a conversational AI interface.
    ///
    /// This service provides a text-based interface for the user to interact with and receive input
    ///  from GPT-based models.
    case gpt

}
