//
//  String+Checksum.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 16/10/2024.
//

import CryptoKit

public extension String {

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
