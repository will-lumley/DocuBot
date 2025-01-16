//
//  Error+Description.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/10/2024.
//

import Foundation

/// An extension on `Error` to provide a custom description of the error.
public extension Error {

    /// A string representation of the error.
    ///
    /// This property prioritises a more detailed, human-readable description of the error:
    /// 1. If the error conforms to `LocalizedError` and provides an `errorDescription`, it returns that value.
    /// 2. Otherwise, it falls back to the `localizedDescription` of the error.
    ///
    /// - Returns: A `String` describing the error.
    var description: String {
        if
            let localError = self as? LocalizedError,
            let errorDescription = localError.errorDescription {
            return errorDescription
        }

        return self.localizedDescription
    }

}
