//
//  Project.swift
//  
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct Project: Hashable, Codable {

    // MARK: - Types

    public enum DirtyCheckResult {
        case clean
        case dirty(newChecksum: String)
    }

    // MARK: - Properties

    /// The unique property for this project. Is `null` if the project hasn't been
    /// inserted into the DB yet
    public let id: Int64?

    /// The file path of the project
    public let path: String

    /// The name the user gave to this project
    public let name: String

    /// The bookmark data that the OS gave to us to securely read the directory
    public let urlBookmarkData: Data

    /// Indicative of if our bookmark data is stale and we need to re-request permission to read the directory
    public let urlBookmarkDataIsStale: Bool

    /// The checksum of all the documentation tokens that exist within our projects path
    public var documentationChecksum: String

    /// Indicative of if the documentation we've loaded into memory is different from the
    /// documentation that exists in the file structure.
    public var isDirty: Bool

    /// An array of all the chats that belong to this Project.
    /// Will be empty until `loadChats(chats:)` is called.
    public var chats = [Chat]()

    /// When this project was created
    public let createdAt: Date

    /// When this project was last updated
    public let updatedAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int64? = nil,
        path: String,
        name: String,
        isDirty: Bool,
        documentationChecksum: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.isDirty = isDirty
        self.documentationChecksum = documentationChecksum
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Project {

    static func loadDocumentationFiles(
        from directory: URL,
        formats: [ProjectSettings.DocumentationFormat]
    ) -> [Document] {
        var strs = [String]()
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil
        )

        while let fileURL = enumerator?.nextObject() as? URL {
            if formats.map(\.extensionName).contains(fileURL.pathExtension) {
                if let content = try? String(contentsOf: fileURL) {
                    strs.append(content)
                }
            }
        }

        return strs.map(Document.init)
    }

    mutating func load(chats: [Chat]) {
        self.chats = chats
    }

    mutating func checkIfDirty(
        with settings: ProjectSettings
    ) throws -> DirtyCheckResult {
        let documents = Project.loadDocumentationFiles(
            from: URL(filePath: self.path),
            formats: settings.supportedFormats
        )
        print("Documents: \(documents)")

        let checksum = try documents.generateChecksum()

        // We are all good, turns out we're not dirty
        if checksum == self.documentationChecksum {
            self.isDirty = false
            return .clean
        }

        return .dirty(newChecksum: checksum)
    }

}
