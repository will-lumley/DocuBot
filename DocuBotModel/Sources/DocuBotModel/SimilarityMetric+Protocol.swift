//
//  SimilarityMetric+Protocol.swift
//  DocuBotModel
//
//  Created by William Lumley on 18/10/2024.
//

import SimilaritySearchKit

extension ProjectSettings.SimilarityMetric {

    var metricProtocol: any DistanceMetricProtocol {
        switch self {
        case .cosine:
            return CosineSimilarity()
        case .dotProduct:
            return DotProduct()
        case .euclideanDistance:
            return EuclideanDistance()
        }
    }

}
