//
//  EmbeddingModel+Protocol.swift
//  DocuBotModel
//
//  Created by William Lumley on 18/10/2024.
//

import SimilaritySearchKit
import SimilaritySearchKitDistilbert
import SimilaritySearchKitMiniLMAll
import SimilaritySearchKitMiniLMMultiQA

extension ProjectSettings.EmbeddingModel {

    /// Converts the embedding model into its corresponding protocol-based implementation.
    ///
    /// This computed property maps the embedding model enumeration to an instance of a type
    /// conforming to `EmbeddingsProtocol`, enabling runtime access to the appropriate embedding logic.
    ///
    /// - Returns: An instance of a type conforming to `EmbeddingsProtocol` corresponding
    /// to the embedding model.
    var embeddingsProtocol: any EmbeddingsProtocol {
        switch self {
        case .distilbert:
            return DistilbertEmbeddings()
        case .miniLmAll:
            return MiniLMEmbeddings()
        case .multiQaMiniLm:
            return MultiQAMiniLMEmbeddings()
        }
    }

}
