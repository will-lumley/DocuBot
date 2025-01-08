//
//  String+Checksum.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 16/10/2024.
//

import CryptoKit

/// An extension on `String` to provide a computed property for generating a checksum using SHA-256.
public extension String {

    /// A SHA-256 checksum of the string.
    ///
    /// This property computes the SHA-256 hash of the string and returns it as a hexadecimal string.
    /// If the string cannot be converted to UTF-8 data, the property returns `nil`.
    ///
    /// - Returns: A `String` containing the hexadecimal representation of the SHA-256 hash,
    /// or `nil` if the string cannot be converted to data.
    var checksum: String? {
        // Convert the combined content to data
        guard let contentData = self.data(using: .utf8) else {
            return nil
        }

        // Generate SHA-256 hash
        let hash = SHA256.hash(data: contentData)

        // Convert hash to hex string
        return hash.map { String(format: "%02x", $0) }.joined()
    }

}
