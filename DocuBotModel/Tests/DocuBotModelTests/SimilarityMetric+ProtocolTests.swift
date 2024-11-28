//
//  SimilarityMetric+ProtocolTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import SimilaritySearchKit
import Testing

struct SimilarityMetricProtocolTests {

    @Test(
        "MetricProtocol Creation",
        arguments: ProjectSettings.SimilarityMetric.allCases
    )
    func metricProtocolCreation(similarityMetric: ProjectSettings.SimilarityMetric) {
        switch similarityMetric {
        case .cosine:
            #expect(similarityMetric.metricProtocol is CosineSimilarity)
        case .dotProduct:
            #expect(similarityMetric.metricProtocol is DotProduct)
        case .euclideanDistance:
            #expect(similarityMetric.metricProtocol is EuclideanDistance)
        }
    }

}
