//
//  ConfigureProjectViewModel+Similarity.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    var similaritySectionTitle: String {
        L10n.ConfigureProject.SimilaritySection.title
    }

    var similaritySectionSubtitle: String {
        L10n.ConfigureProject.SimilaritySection.subtitle
    }

    var embeddingModelTitle: String {
        L10n.ConfigureProject.AdvancedSection.embeddingModel
    }

    var similarityMetricTitle: String {
        L10n.ConfigureProject.AdvancedSection.similarityMetric
    }

    func resetSimilarityOptions() {
        self.embeddingModel = .distilbert
        self.similarityMetric = .cosine
    }

}
