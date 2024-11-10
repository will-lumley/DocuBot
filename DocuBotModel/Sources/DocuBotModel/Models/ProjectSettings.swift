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

    public enum EmbeddingModel: String, CaseIterable, Hashable, Codable, Sendable {
        case distilbert
        case miniLmAll
        case multiQaMiniLm
    }

    public enum SimilarityMetric: String, CaseIterable, Hashable, Codable, Sendable {
        case cosine
        case dotProduct
        case euclideanDistance
    }

    public enum DocumentationFormat: Hashable, CaseIterable, Codable, Sendable {
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
