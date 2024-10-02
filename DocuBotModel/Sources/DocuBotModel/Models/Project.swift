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

    public enum DocumentError: Error {
        case invalidPath
        case failedToLoad
        case noBookmarkData
        case bookmarkIsStale
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
    public let urlBookmarkData: Data?

    /// Indicative of if our bookmark data is stale and we need to re-request permission to read the directory
    public var urlBookmarkDataIsStale: Bool

    /// The checksum of all the documentation tokens that exist within our projects path.
    /// This is a transitive property and is only stored on the model layer.
    public var documentationChecksum: String?

    /// Indicative of if the documentation we've loaded into memory is different from the
    /// documentation that exists in the file structure.
    /// This is a transitive property and is only stored on the model layer.
    public var isDirty: Bool

    /// An array of all the documents that belong to this Project.
    /// Will be `nil` until `loadDocuments()` is called.
    /// This is a transitive property and is only stored on the model layer.
    public var documents: [Document]?

    /// An array of all the chats that belong to this Project.
    /// Will be `nil` until `loadChats(chats:)` is called.
    public var chats: [Chat]?

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
        urlBookmarkData: Data?,
        urlBookmarkDataIsStale: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.isDirty = isDirty
        self.urlBookmarkData = urlBookmarkData
        self.urlBookmarkDataIsStale = urlBookmarkDataIsStale
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Project {

    var loadedChats: Bool {
        self.chats != nil
    }

    var loadedDocments: Bool {
        self.documents != nil
    }

    mutating func load(chats: [Chat]) {
        self.chats = chats
    }

    mutating func sync(_ settings: ProjectSettings) throws {
        // Load our documents into memory
        try self.loadDocuments(settings)
    }

}

// MARK: - Private

private extension Project {

    mutating func loadDocuments(_ settings: ProjectSettings) throws {
        guard let urlBookmarkData else {
            throw DocumentError.noBookmarkData
        }
        var isStale = false
        let directory = try URL(
            resolvingBookmarkData: urlBookmarkData,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )

        // Update our `isStale` status
        self.urlBookmarkDataIsStale = isStale

        // Open up our access
        guard directory.startAccessingSecurityScopedResource() else {
            throw DocumentError.bookmarkIsStale
        }

        let formats = settings.supportedFormats
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: nil
        )

        // Create/Reset our document array
        self.documents = .init()

        // Enumerate over each file in the directory
        while let fileURL = enumerator?.nextObject() as? URL {
            let rawFileExtension = fileURL.pathExtension
            let fileExtension = ProjectSettings.DocumentationFormat(rawValue: rawFileExtension)

            // If this file has the extension that user indicated that they're
            // okay with us touching.
            guard formats.contains(fileExtension) else {
                continue
            }

            // Extract the documents content as a string file
            guard let content = try? String(String(contentsOf: fileURL)) else {
                continue
            }

            let document = Document(
                url: fileURL,
                fileFormat: fileExtension,
                content: content
            )
            self.documents?.append(document)
        }

        // Close our access
        directory.stopAccessingSecurityScopedResource()

        // Generate our checksum so we can tell for later if we need to re-sync
        let checksum = try self.documents?.generateChecksum()
        self.documentationChecksum = checksum
    }

}
