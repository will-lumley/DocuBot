//
//  EmbeddingModel+ProtocolTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import SimilaritySearchKit
import SimilaritySearchKitDistilbert
import SimilaritySearchKitMiniLMAll
import SimilaritySearchKitMiniLMMultiQA
import Testing

struct EmbeddingModelProtocolTests {

    @Test(
        "EmbeddingsProtocol Creation",
        arguments: ProjectSettings.EmbeddingModel.allCases
    )
    func embeddingsProtocolCreation(embeddingModel: ProjectSettings.EmbeddingModel) {
        switch embeddingModel {
        case .distilbert:
            #expect(embeddingModel.embeddingsProtocol is DistilbertEmbeddings)
        case .miniLmAll:
            #expect(embeddingModel.embeddingsProtocol is MiniLMEmbeddings)
        case .multiQaMiniLm:
            #expect(embeddingModel.embeddingsProtocol is MultiQAMiniLMEmbeddings)
        }
    }

}
