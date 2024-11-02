//
//  String+Trim.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 16/10/2024.
//

import Foundation

public extension String {

    func removing(value: String) -> String {
        return self.replacingOccurrences(of: value, with: "")
    }

    func removingPrefix(upTo pattern: String) -> String {
        // Escaping any special characters in the pattern to be used in regex
        let escapedPattern = NSRegularExpression.escapedPattern(for: pattern)
        // Building the regex to match everything up to and including the pattern
        let regexPattern = ".*?\(escapedPattern)"

        if let range = self.range(of: regexPattern, options: .regularExpression) {
            return self.replacingCharacters(in: range, with: "")
        }

        // Return the original string if the pattern isn't found
        return self
    }

    /// Removes all trailing newline characters (`\n`, `\r`, `\r\n`) from the end of the string.
    func trimmingTrailingNewlines() -> String {
        var trimmed = self
        while trimmed.hasSuffix("\n") || trimmed.hasSuffix("\r") {
            trimmed.removeLast()
        }

        return trimmed
    }

    func trim(by length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index])
        } else {
            return self
        }
    }

}
