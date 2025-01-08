//
//  SimilarityMetric+ViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 18/10/2024.
//

import DocuBotModel

public extension ProjectSettings.SimilarityMetric {

    /// A human-readable title for the similarity metric.
    ///
    /// - Returns: A localized string representing the title of the similarity metric.
    var title: String {
        switch self {
        case .cosine:
            return L10n.SimilarityMetric.Cosine.title
        case .dotProduct:
            return L10n.SimilarityMetric.DotProduct.title
        case .euclideanDistance:
            return L10n.SimilarityMetric.EuclideanDistance.title
        }
    }

}
