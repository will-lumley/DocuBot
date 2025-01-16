//
//  PersistenceError.swift
//  DocuBotService
//
//  Created by William Lumley on 7/1/2025.
//

import Foundation

/// An enumeration representing errors related to persistence operations.
public enum PersistenceError: LocalizedError {

    /// Indicates that a requested value was not found in the persistence layer.
    case valueNotFound

    /// A localized description of the persistence error.
    ///
    /// - Returns: A string describing the error, or `nil` if no description is available.
    public var errorDescription: String? {
        switch self {
        case .valueNotFound:
            return L10n.Error.Persistence.valueNotFound
        }
    }
}
