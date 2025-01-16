//
//  EmbeddingModel+ViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 18/10/2024.
//

import DocuBotModel

public extension ProjectSettings.EmbeddingModel {

    /// A human-readable title for the embedding model.
    ///
    /// - Returns: A localized string representing the title of the embedding model.
    var title: String {
        switch self {
        case .distilbert:
            return L10n.EmbeddingModel.Distilbert.title
        case .miniLmAll:
            return L10n.EmbeddingModel.MiniLme.title
        case .multiQaMiniLm:
            return L10n.EmbeddingModel.MultiQaMiniLme.title
        }
    }

}
