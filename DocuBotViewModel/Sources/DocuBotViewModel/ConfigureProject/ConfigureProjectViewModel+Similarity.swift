//
//  ConfigureProjectViewModel+Similarity.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    /// The title for the similarity section in the configuration UI.
    ///
    /// - Returns: A localized string representing the title of the similarity section.
    var similaritySectionTitle: String {
        L10n.ConfigureProject.SimilaritySection.title
    }

    /// The subtitle for the similarity section in the configuration UI.
    ///
    /// - Returns: A localized string providing additional context for the similarity section.
    var similaritySectionSubtitle: String {
        L10n.ConfigureProject.SimilaritySection.subtitle
    }

    
    /// The title for the embedding model configuration option.
    ///
    /// - Returns: A localized string representing the title of the embedding model option.
    var embeddingModelTitle: String {
        L10n.ConfigureProject.AdvancedSection.embeddingModel
    }

    /// The title for the similarity metric configuration option.
    ///
    /// - Returns: A localized string representing the title of the similarity metric option.
    var similarityMetricTitle: String {
        L10n.ConfigureProject.AdvancedSection.similarityMetric
    }

    /// Resets the similarity-related options to their default values.
    ///
    /// - Discussion:
    /// This method sets the `embeddingModel` to `.distilbert` and
    /// the `similarityMetric` to `.cosine`, which are the default values for these options.
    ///
    /// - Example:
    /// ```swift
    /// viewModel.resetSimilarityOptions()
    /// print(viewModel.embeddingModel) // Outputs `.distilbert`
    /// print(viewModel.similarityMetric) // Outputs `.cosine`
    /// ```
    func resetSimilarityOptions() {
        self.embeddingModel = .distilbert
        self.similarityMetric = .cosine
    }

}
