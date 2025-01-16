//
//  Document.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import CryptoKit
import Foundation

public struct Document {

    // MARK: - Types

    public enum ChecksumGenerationError: Error {
        case failedStringToDataConversion
    }

    // MARK: - Properties

    public let content: String

    // MARK: - Lifecycle

    public init(content: String) {
        self.content = content
    }

}

// MARK: - [Document]

public extension Array where Element == Document {

    func generateChecksum() throws -> String {
        // Concatenate all document contents into a single string
        let combinedContent = self.map(\.content).joined(separator: "\n")
        
        // Convert the combined content to data
        guard let contentData = combinedContent.data(using: .utf8) else {
            throw Document.ChecksumGenerationError.failedStringToDataConversion
        }

        // Generate SHA-256 hash
        let hash = SHA256.hash(data: contentData)

        // Convert hash to hex string
        return hash.map { String(format: "%02x", $0) }.joined()
    }


}
