//
//  Project.swift
//
//
//  Created by William Lumley on 12/7/2024.
//

import Foundation

public struct ProjectSettings: Hashable, Codable, Sendable {

    // MARK: - Types

    public enum Language: Hashable, CaseIterable, Codable, Sendable {
        case english
    }

    public enum EmbeddingModel: String, CaseIterable, Hashable, Codable, Sendable, Equatable {
        case distilbert
        case miniLmAll
        case multiQaMiniLm
    }

    public enum SimilarityMetric: String, CaseIterable, Hashable, Codable, Sendable, Equatable {
        case cosine
        case dotProduct
        case euclideanDistance
    }

    public enum DocumentationFormat: Hashable, CaseIterable, Codable, Sendable, Equatable {
        public static var allCases: [ProjectSettings.DocumentationFormat] {
            [.rtf, .txt, .html, .md]
        }

        case rtf
        case txt
        case html
        case md
        case other(String)

        init(rawValue: String) {
            switch rawValue {
            case "rtf": self = .rtf
            case "txt": self = .txt
            case "html": self = .html
            case "md": self = .md
            default: self = .other(rawValue)
            }
        }
    }

    // MARK: - Properties

    public let id: Int64?
    public let projectID: Int64
    public let modelID: Int64

    public let supportedFormats: [DocumentationFormat]
    public let language: Language

    public let embeddingModel: EmbeddingModel
    public let similarityMetric: SimilarityMetric
    public let seed: Int
    public let topK: Int
    public let topP: Double
    public let contextLength: Int
    public let temperature: Double
    public let batchSize: Int
    public let stopSequence: String?
    public let maxTokenCount: Int
    public let systemPrompt: String
    public let strictMode: Bool

    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Lifecycle

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
        contextLength: Int,
        temperature: Double,
        batchSize: Int,
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
        self.contextLength = contextLength
        self.temperature = temperature
        self.batchSize = batchSize
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

    var otherFormats: [DocumentationFormat] {
        self.supportedFormats
            .filter { $0.isOther }
    }

    func isEnabled(_ format: DocumentationFormat) -> Bool {
        return self.supportedFormats.contains(format)
    }

}

// MARK: - Equatable

extension ProjectSettings: Equatable {

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
            lhs.contextLength == rhs.contextLength &&
            lhs.temperature == rhs.temperature &&
            lhs.batchSize == rhs.batchSize &&
            lhs.stopSequence == rhs.stopSequence &&
            lhs.maxTokenCount == rhs.maxTokenCount &&
            lhs.systemPrompt == rhs.systemPrompt &&
            lhs.strictMode == rhs.strictMode &&

            lhs.createdAt.secondsFrom1970 == rhs.createdAt.secondsFrom1970 &&
            lhs.updatedAt.secondsFrom1970 == rhs.updatedAt.secondsFrom1970
    }

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
            self.contextLength == rhs.contextLength &&
            self.temperature == rhs.temperature &&
            self.batchSize == rhs.batchSize &&
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

    var isOther: Bool {
        switch self {
        case .other:
            return true
        default:
            return false
        }
    }

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
        case .other(let value):
            return value
        }
    }

}

// MARK: - ProjectSettings.Language

extension ProjectSettings.Language: Identifiable {

    public var id: Self {
        self
    }

}
