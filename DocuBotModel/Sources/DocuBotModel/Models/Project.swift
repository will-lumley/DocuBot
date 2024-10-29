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
    public var path: String

    /// The name the user gave to this project
    public let name: String

    /// The bookmark data that the OS gave to us to securely read the directory
    public var urlBookmarkData: Data

    /// The checksum of all the documentation tokens that exist within our projects path.
    public var documentationChecksum: String?

    /// An array of all the documents that belong to this Project.
    /// Will be `nil` until `loadDocuments()` is called.
    /// This is a transitive property and is only stored on the model layer.
    public var documents: [Document]?

    /// An array of example questions that are relevant to this Project.
    public var exampleQuestions: [String]

    /// The warning state that exists for this project
    public private(set) var alertStatus: AlertStatus

    /// Indicative of if we need to do a full resync when the next sync occurs
    public var needsFullResync: Bool

    /// When this project was created
    public let createdAt: Date

    /// When this project was last updated
    public let updatedAt: Date

    // MARK: - Lifecycle

    public init(
        id: Int64? = nil,
        path: String,
        name: String,
        urlBookmarkData: Data,
        documentationCheckSum: String?,
        exampleQuestions: [String],
        alertStatus: AlertStatus,
        needsFullResync: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.documentationChecksum = documentationCheckSum
        self.urlBookmarkData = urlBookmarkData
        self.exampleQuestions = exampleQuestions
        self.alertStatus = alertStatus
        self.needsFullResync = needsFullResync
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Project {

    var loadedDocments: Bool {
        self.documents != nil
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
            guard
                let embeddings = document.embeddings,
                let documentID = document.id
            else {
                continue
            }

            for embedding in embeddings {
                await similarityIndex.addItem(
                    id: UUID().uuidString,
                    text: embedding.chunk,
                    metadata: ["id": "\(documentID)"],
                    embedding: embedding.embedding
                )
            }
        }

        let results = await similarityIndex.search(query)
        return results
    }

    mutating func set(alertStatus: AlertStatus) {
        // If we're clearing out any alert status, let it pass
        if alertStatus == .none {
            self.alertStatus = alertStatus
        }

        // If our new alert has a higher priority, let it pass
        if alertStatus.rawValue > self.alertStatus.rawValue {
            self.alertStatus = alertStatus
        }
    }

    mutating func clearDirtyStatus() {
        // If we're dirty, we can remove the alert
        if self.alertStatus.isDirty {
            self.alertStatus = .none
        }
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

// MARK: - DocumentFetchError

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
