//
//  SimilarityMetric+ViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

struct SimilarityMetricViewModelTests {

    typealias SimilarityMetric = ProjectSettings.SimilarityMetric

    @Test("Title")
    func title() {
        #expect(SimilarityMetric.cosine.title == "Cosine")
        #expect(SimilarityMetric.dotProduct.title == "Dot Product")
        #expect(SimilarityMetric.euclideanDistance.title == "Euclidean Distance")
    }

}
