//
//  String+TrimNewline.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 11/10/2024.
//

import Foundation

public extension String {

    /// Removes all trailing newline characters (`\n`, `\r`, `\r\n`) from the end of the string.
    func trimmingTrailingNewlines() -> String {
        var trimmed = self
        while trimmed.hasSuffix("\n") || trimmed.hasSuffix("\r") {
            trimmed.removeLast()
        }

        return trimmed
    }

}
