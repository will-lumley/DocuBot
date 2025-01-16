//
//  SimilarityMetric+Protocol.swift
//  DocuBotModel
//
//  Created by William Lumley on 18/10/2024.
//

import SimilaritySearchKit

extension ProjectSettings.SimilarityMetric {

    /// Converts the similarity metric into its corresponding protocol-based implementation.
    ///
    /// This computed property maps the similarity metric enumeration to an instance of a type
    /// conforming to `DistanceMetricProtocol`, enabling runtime access to the appropriate metric logic.
    ///
    /// - Returns: An instance of a type conforming to `DistanceMetricProtocol` corresponding
    /// to the similarity metric.
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
