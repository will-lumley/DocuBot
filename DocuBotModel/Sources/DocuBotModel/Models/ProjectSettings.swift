//
//  Project.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

/// A model representing the settings for a project.
///
/// The `ProjectSettings` struct contains configuration options that define how a project operates,
/// including embedding models, similarity metrics, supported formats, and more.
public struct ProjectSettings: Hashable, Codable, Sendable {

    // MARK: - Types

    /// The language used for the project settings.
    public enum Language: Hashable, CaseIterable, Codable, Sendable {
        /// English language setting.
        case english
    }

    /// The embedding models available for the project.
    public enum EmbeddingModel: String, CaseIterable, Hashable, Codable, Sendable {
        /// DistilBERT embedding model.
        case distilbert

        /// MiniLM All embedding model.
        case miniLmAll

        /// MultiQA MiniLM embedding model.
        case multiQaMiniLm
    }

    /// The similarity metrics available for comparing text.
    public enum SimilarityMetric: String, CaseIterable, Hashable, Codable, Sendable {
        /// Cosine similarity metric.
        case cosine

        /// Dot product similarity metric.
        case dotProduct

        /// Euclidean distance similarity metric.
        case euclideanDistance
    }

    /// The formats supported for documentation.
    public enum DocumentationFormat: Hashable, CaseIterable, Codable, Sendable {

        /// All the cases apart from .other
        public static var allCases: [ProjectSettings.DocumentationFormat] {
            [.rtf, .txt, .html, .md, .pdf, .word]
        }

        /// Rich Text Format.
        case rtf

        /// Plain text format.
        case txt

        /// HTML format.
        case html

        /// Markdown format.
        case md

        /// PDF format.
        case pdf

        /// MSWord format.
        case word

        /// Any other format represented by a string.
        case other(String)

        /// Initializes a documentation format from a raw string value.
        ///
        /// - Parameter rawValue: The raw string value to convert to a documentation format.
        init(rawValue: String) {
            switch rawValue {
            case "rtf": self = .rtf
            case "txt": self = .txt
            case "html": self = .html
            case "md": self = .md
            case "pdf": self = .pdf
            case "docx": self = .word
            default: self = .other(rawValue)
            }
        }
    }

    // MARK: - Properties

    /// The unique identifier for the project settings.
    public let id: Int64?

    /// The identifier of the associated project.
    public let projectID: Int64

    /// The identifier of the associated embedding model.
    public let modelID: Int64

    /// The supported documentation formats.
    public let supportedFormats: [DocumentationFormat]

    /// The language used for the project settings.
    public let language: Language

    /// The embedding model used for generating embeddings.
    public let embeddingModel: EmbeddingModel

    /// The similarity metric used for text comparisons.
    public let similarityMetric: SimilarityMetric

    /// A random seed used for reproducibility.
    public let seed: Int

    /// The top K value for controlling token generation.
    public let topK: Int

    /// The top P value for controlling token generation.
    public let topP: Double

    /// The temperature value for controlling randomness in token generation.
    public let temperature: Double

    /// The stop sequence used to terminate text generation.
    public let stopSequence: String?

    /// The maximum token count for text generation.
    public let maxTokenCount: Int

    /// The system prompt used to provide context to the model.
    public let systemPrompt: String

    /// A flag indicating whether strict mode is enabled.
    public let strictMode: Bool

    /// The creation timestamp for the settings.
    public let createdAt: Date

    /// The last update timestamp for the settings.
    public let updatedAt: Date

    // MARK: - Lifecycle

    /// Creates a new instance of `ProjectSettings`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the settings (optional).
    ///   - projectID: The associated project identifier.
    ///   - modelID: The associated embedding model identifier.
    ///   - supportedFormats: The documentation formats supported.
    ///   - language: The language used.
    ///   - embeddingModel: The embedding model used.
    ///   - similarityMetric: The similarity metric used.
    ///   - seed: The random seed for reproducibility.
    ///   - topK: The top K value for token generation.
    ///   - topP: The top P value for token generation.
    ///   - temperature: The randomness control value.
    ///   - stopSequence: The stop sequence for text generation (optional).
    ///   - maxTokenCount: The maximum token count for text generation.
    ///   - systemPrompt: The system prompt for model context.
    ///   - strictMode: Indicates if strict mode is enabled.
    ///   - createdAt: The creation timestamp.
    ///   - updatedAt: The last update timestamp.
    public init(
        id: Int64? = nil,
        projectID: Int64,
        modelID: Int64,
        supportedFormats: [DocumentationFormat],
        language: Language,
        embeddingModel: EmbeddingModel,
        similarityMetric: SimilarityMetric,
        seed: Int,
        topK: Int,
        topP: Double,
        temperature: Double,
        stopSequence: String?,
        maxTokenCount: Int,
        systemPrompt: String,
        strictMode: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.projectID = projectID
        self.modelID = modelID
        self.supportedFormats = supportedFormats
        self.language = language
        self.embeddingModel = embeddingModel
        self.similarityMetric = similarityMetric
        self.seed = seed
        self.topK = topK
        self.topP = topP
        self.temperature = temperature
        self.stopSequence = stopSequence
        self.maxTokenCount = maxTokenCount
        self.systemPrompt = systemPrompt
        self.strictMode = strictMode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

// MARK: - Public

public extension ProjectSettings {

    /// Retrieves a list of documentation formats classified as "other."
    ///
    /// This property filters the `supportedFormats` to include only those
    /// that are categorized as `.other`.
    ///
    /// - Returns: An array of `DocumentationFormat` values classified as "other."
    var otherFormats: [DocumentationFormat] {
        self.supportedFormats
            .filter { $0.isOther }
    }

    /// Checks if a specific documentation format is enabled.
    ///
    /// This method verifies whether the provided format exists in the `supportedFormats`.
    ///
    /// - Parameter format: The `DocumentationFormat` to check.
    /// - Returns: `true` if the format is enabled, otherwise `false`.
    func isEnabled(_ format: DocumentationFormat) -> Bool {
        return self.supportedFormats.contains(format)
    }

}

// MARK: - Equatable

extension ProjectSettings: Equatable {

    /// Compares two `ProjectSettings` instances for equality.
    ///
    /// The comparison checks all properties, including timestamps in seconds.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ProjectSettings` to compare.
    ///   - rhs: The right-hand side `ProjectSettings` to compare.
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    public static func == (lhs: ProjectSettings, rhs: ProjectSettings) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.projectID == rhs.projectID &&
            lhs.modelID == rhs.modelID &&
            lhs.supportedFormats == rhs.supportedFormats &&
            lhs.similarityMetric == rhs.similarityMetric &&
            lhs.seed == rhs.seed &&
            lhs.topK == rhs.topK &&
            lhs.topP == rhs.topP &&
            lhs.temperature == rhs.temperature &&
            lhs.stopSequence == rhs.stopSequence &&
            lhs.maxTokenCount == rhs.maxTokenCount &&
            lhs.systemPrompt == rhs.systemPrompt &&
            lhs.strictMode == rhs.strictMode &&
            lhs.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            lhs.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

    /// Compares two `ProjectSettings` instances, ignoring their `id`.
    ///
    /// The comparison checks all properties except for `id`, including timestamps in seconds.
    ///
    /// - Parameter rhs: The `ProjectSettings` to compare against.
    /// - Returns: `true` if all properties except `id` are equal, otherwise `false`.
    public func isEqualToIgnoringID(
        _ rhs: ProjectSettings
    ) -> Bool {
        return
            self.projectID == rhs.projectID &&
            self.modelID == rhs.modelID &&
            self.supportedFormats == rhs.supportedFormats &&
            self.similarityMetric == rhs.similarityMetric &&
            self.seed == rhs.seed &&
            self.topK == rhs.topK &&
            self.topP == rhs.topP &&
            self.temperature == rhs.temperature &&
            self.stopSequence == rhs.stopSequence &&
            self.maxTokenCount == rhs.maxTokenCount &&
            self.systemPrompt == rhs.systemPrompt &&
            self.strictMode == rhs.strictMode &&
            self.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            self.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

}

// MARK: - ProjectSettings.DocumentationFormat

public extension ProjectSettings.DocumentationFormat {

    /// Indicates whether the format is classified as "other."
    ///
    /// This property returns `true` if the format is of type `.other`, otherwise `false`.
    var isOther: Bool {
        switch self {
        case .other:
            return true
        default:
            return false
        }
    }

    /// Retrieves the file extension corresponding to the documentation format.
    ///
    /// This property provides a human-readable file extension for each format.
    ///
    /// - Returns: A string representing the file extension, or the custom string for `.other`.
    var extensionName: String {
        switch self {
        case .html:
            return "html"
        case .md:
            return "md"
        case .txt:
            return "txt"
        case .rtf:
            return "rtf"
        case .pdf:
            return "pdf"
        case .word:
            return "docx"
        case .other(let value):
            return value
        }
    }

}

// MARK: - ProjectSettings.Language

extension ProjectSettings.Language: Identifiable {

    /// The unique identifier for the language.
    ///
    /// The language itself serves as its identifier.
    public var id: Self {
        self
    }

}
