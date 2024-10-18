//
//  EmbeddingModel+ViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 18/10/2024.
//

import DocuBotModel

public extension ProjectSettings.EmbeddingModel {

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
