//
//  Error+Description.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/10/2024.
//

import Foundation

public extension Error {

    var description: String {
        if
            let localError = self as? LocalizedError,
            let errorDescription = localError.errorDescription {
            return errorDescription
        }

        return self.localizedDescription
    }

}
