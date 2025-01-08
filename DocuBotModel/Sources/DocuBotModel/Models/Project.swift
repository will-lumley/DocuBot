//
//  Project.swift
//  
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation
import SimilaritySearchKit
import SimilaritySearchKitDistilbert

/// A model representing a project within the system.
///
/// The `Project` struct contains metadata, settings, and documents related to a project,
/// enabling document processing and similarity-based queries.
public struct Project: Hashable, Codable, Sendable {

    // MARK: - Types

    /// Errors that may occur while working with a `Project`.
    public enum ProjectError: LocalizedError {
        /// Indicates that the project is missing an `id`.
        case missingID
    }

    /// Errors that may occur while fetching project documents.
    public enum DocumentFetchError: LocalizedError {
        /// Indicates that no documents were found for the project.
        case noDocumentsFound

        /// Indicates that indexing has not been performed on the documents.
        case noIndexing
    }

    // MARK: - Properties

    /// The unique identifier for this project. May be `nil` if the project has not been inserted into the database.
    public let id: Int64?

    /// The file path of the project.
    public var path: String

    /// The user-defined name for the project.
    public let name: String

    /// Bookmark data provided by the OS for secure directory access.
    public var urlBookmarkData: Data

    /// The checksum of all documentation tokens in the project's path.
    public var documentationChecksum: String?

    /// The documents belonging to this project.
    ///
    /// This property is transient and will be `nil` until `loadDocuments()` is called.
    public var documents: [Document]?

    /// Example questions relevant to the project.
    public var exampleQuestions: [String]

    /// The alert status for the project, representing warnings or errors.
    public private(set) var alertStatus: AlertStatus

    /// The creation date of the project.
    public let createdAt: Date

    /// The last updated date of the project.
    public let updatedAt: Date

    // MARK: - Lifecycle

    /// Initializes a new `Project` instance with the provided properties.
    ///
    /// This initializer is used to create a `Project` object with the specified attributes, including i
    /// ts metadata, path, and state information.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the project (optional; default is `nil` if not yet persisted in a database).
    ///   - path: The file path where the project resides.
    ///   - name: The user-defined name of the project.
    ///   - urlBookmarkData: A `Data` object containing a secure bookmark for accessing
    ///   the project directory.
    ///   - documentationCheckSum: An optional checksum representing the project's
    ///   documentation content.
    ///   - exampleQuestions: An array of example questions relevant to the project.
    ///   - alertStatus: The current alert status for the project (e.g., `.none`, `.warning`, or `.error`).
    ///   - createdAt: The timestamp indicating when the project was created.
    ///   - updatedAt: The timestamp indicating when the project was last updated.
    ///
    /// - Returns: A new `Project` instance configured with the specified attributes.
    ///
    /// # Example
    /// ```swift
    /// let project = Project(
    ///     id: 42,
    ///     path: "/Users/testuser/Projects/MyProject",
    ///     name: "My Project",
    ///     urlBookmarkData: Data(),
    ///     documentationCheckSum: "abc123",
    ///     exampleQuestions: ["What is the purpose?", "How to use this project?"],
    ///     alertStatus: .none,
    ///     createdAt: Date(),
    ///     updatedAt: Date()
    /// )
    /// ```
    public init(
        id: Int64? = nil,
        path: String,
        name: String,
        urlBookmarkData: Data,
        documentationCheckSum: String?,
        exampleQuestions: [String],
        alertStatus: AlertStatus,
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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension Project {

    /// Indicates whether the project's documents have been loaded.
    ///
    /// - Returns: `true` if the documents have been loaded, otherwise `false`.
    var loadedDocuments: Bool {
        self.documents != nil
    }

    /// Loads the given documents into the project.
    ///
    /// - Parameter documents: An array of `Document` objects to associate with the project.
    mutating func load(documents: [Document]) {
        self.documents = documents
    }

    /// Fetches relevant documentation for a given query using the project's settings.
    ///
    /// This method creates a similarity index, adds the project's documents, and performs a query.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - settings: The project settings to use for the search.
    ///   - floor: The minimum similarity score threshold.
    /// - Returns: An array of `SimilarityIndex.SearchResult` objects.
    /// - Throws: A `DocumentFetchError` if no documents are loaded.
    func fetchRelevantDocumentation(
        for query: String,
        with settings: ProjectSettings,
        with floor: Double
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

        var results = await similarityIndex.search(query)

        // Filter out any results that are lower than our floor
        results = results.filter {
            $0.score >= Float(Float(floor) / 100)
        }

        return results
    }

    /// Updates the alert status for the project.
    ///
    /// The new alert status will replace the existing one only if it has a higher priority
    /// or if it is `.none`.
    ///
    /// - Parameter alertStatus: The new alert status to set.
    mutating func set(alertStatus: AlertStatus) {
        // If we're clearing out any alert status, let it pass
        if alertStatus == .none {
            self.alertStatus = alertStatus
            return
        }

        // If our new alert has a higher priority, let it pass
        if alertStatus.rawValue > self.alertStatus.rawValue {
            self.alertStatus = alertStatus
        }
    }

    /// Clears the dirty warning state from the project's alert status, if present.
    mutating func clearDirtyStatus() {
        // If we're dirty, we can remove the alert
        if self.alertStatus.isDirty {
            self.alertStatus = .none
        }
    }

}

// MARK: - Equatable

extension Project: Equatable {

    /// Compares two `Project` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `Project` to compare.
    ///   - rhs: The right-hand side `Project` to compare.
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    public static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id &&
            lhs.path == rhs.path &&
            lhs.name == rhs.name &&
            lhs.urlBookmarkData == rhs.urlBookmarkData &&
            lhs.documentationChecksum == rhs.documentationChecksum &&
            lhs.documents == rhs.documents &&
            lhs.exampleQuestions == rhs.exampleQuestions &&
            lhs.alertStatus == rhs.alertStatus &&
            lhs.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            lhs.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

    /// Compares two `Project` instances for equality, ignoring their `id` values.
    ///
    /// - Parameter rhs: The `Project` to compare against.
    /// - Returns: `true` if all properties except `id` are equal, otherwise `false`.
    public func isEqualToIgnoringID(
        _ rhs: Project
    ) -> Bool {
        return self.path == rhs.path &&
            self.name == rhs.name &&
            self.urlBookmarkData == rhs.urlBookmarkData &&
            self.documentationChecksum == rhs.documentationChecksum &&
            self.documents == rhs.documents &&
            self.exampleQuestions == rhs.exampleQuestions &&
            self.alertStatus == rhs.alertStatus &&
            self.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            self.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

}

// MARK: - ProjectError

public extension Project.ProjectError {

    /// A localized description of the project error.
    var errorDescription: String? {
        switch self {
        case .missingID:
            return L10n.Error.Project.missingID
        }
    }

}

// MARK: - DocumentFetchError

public extension Project.DocumentFetchError {

    /// A localized description of the document fetch error.
    var errorDescription: String? {
        switch self {
        case .noDocumentsFound:
            return L10n.Error.Project.DocumentFetch.noDocumentsFound
        case .noIndexing:
            return L10n.Error.Project.DocumentFetch.noIndexing
        }
    }

}
