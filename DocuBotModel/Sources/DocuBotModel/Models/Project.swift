//
//  Project.swift
//  
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import SimilaritySearchKit
import SimilaritySearchKitDistilbert

public struct Project: Hashable, Codable, Sendable {

    // MARK: - Types

    public enum ProjectError: LocalizedError {
        case missingID
    }

    public enum DocumentFetchError: LocalizedError {
        case noDocumentsFound
        case noIndexing
    }

    // MARK: - Properties

    /// The unique property for this project. Is `nil` if the project hasn't been
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

    /// An array of example questions that are relevant to this Project.
    public var exampleQuestions: [String]

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
        exampleQuestions: [String],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.isDirty = isDirty
        self.urlBookmarkData = urlBookmarkData
        self.urlBookmarkDataIsStale = urlBookmarkDataIsStale
        self.exampleQuestions = exampleQuestions
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

    mutating func load(documents: [Document]) {
        self.documents = documents
    }

    func fetchRelevantDocumentation(
        for query: String,
        with settings: ProjectSettings
    ) async throws -> [SimilarityIndex.SearchResult] {
        guard let documents = self.documents else {
            throw Project.DocumentFetchError.noDocumentsFound
        }

        // Create our index
        let similarityIndex = await SimilarityIndex(
            model: settings.embeddingModel.embeddingsProtocol,
            metric: settings.similarityMetric.metricProtocol
        )

        // Add each document to our index
        for document in documents {
            guard let embeddings = document.embeddings else {
                continue
            }

            for embedding in embeddings {
                await similarityIndex.addItem(
                    id: UUID().uuidString,
                    text: embedding.chunk,
                    metadata: ["id": "\(document.id ?? -1)"],
                    embedding: embedding.embedding
                )
            }
        }

        let results = await similarityIndex.search(query)
        return results
    }

}

// MARK: - ProjectError

public extension Project.ProjectError {

    var errorDescription: String? {
        switch self {
        case .missingID:
            return L10n.Error.Project.missingID
        }
    }

}

// MARK: - ProjectError

public extension Project.DocumentFetchError {

    var errorDescription: String? {
        switch self {
        case .noDocumentsFound:
            return L10n.Error.Project.DocumentFetch.noDocumentsFound
        case .noIndexing:
            return L10n.Error.Project.DocumentFetch.noIndexing
        }
    }

}
