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
