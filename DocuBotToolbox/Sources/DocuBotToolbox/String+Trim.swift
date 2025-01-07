//
//  String+Trim.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 16/10/2024.
//

import Foundation

/// An extension on `String` to provide utility methods for string manipulation.
public extension String {
    
    /// Removes all occurrences of a specified substring from the string.
    ///
    /// - Parameter value: The substring to remove.
    /// - Returns: A new string with all occurrences of the specified substring removed.
    func removing(value: String) -> String {
        return self.replacingOccurrences(of: value, with: "")
    }

    /// Removes everything from the beginning of the string up to and including a specified pattern.
    ///
    /// This method uses a regular expression to find the specified pattern and removes all characters
    /// up to and including the first match.
    ///
    /// - Parameter pattern: The substring or pattern to match.
    /// - Returns: A new string with the characters up to and including the pattern removed,
    /// or the original string if the pattern is not found.
    func removingPrefix(upTo pattern: String) -> String {
        // Escaping any special characters in the pattern to be used in regex
        let escapedPattern = NSRegularExpression.escapedPattern(for: pattern)

        // Building the regex to match everything up to and
        // including the pattern
        let regexPattern = ".*?\(escapedPattern)"

        if let range = self.range(of: regexPattern, options: .regularExpression) {
            return self.replacingCharacters(in: range, with: "")
        }

        // Return the original string if the pattern isn't found
        return self
    }

    /// Removes all trailing newline characters (`\n`, `\r`, `\r\n`) from the end of the string.
    ///
    /// - Returns: A new string with all trailing newline characters removed.
    func trimmingTrailingNewlines() -> String {
        var trimmed = self
        while trimmed.hasSuffix("\n") || trimmed.hasSuffix("\r") {
            trimmed.removeLast()
        }

        return trimmed
    }

    /// Trims the string to a specified maximum length.
    ///
    /// If the string exceeds the specified length, it is truncated to that length.
    /// If the string's length is less than or equal to the specified length, the original string is returned.
    ///
    /// - Parameter length: The maximum number of characters to retain.
    /// - Returns: A new string trimmed to the specified length, or the original string if its length is shorter than or equal to the specified length.
    func trim(by length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index])
        } else {
            return self
        }
    }

}
