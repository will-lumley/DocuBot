//
//  EmbeddingModel+ViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

struct EmbeddingModelViewModelTests {

    typealias EmbeddingModel = ProjectSettings.EmbeddingModel

    @Test("Title")
    func title() {
        #expect(EmbeddingModel.distilbert.title == "Distilbert")
        #expect(EmbeddingModel.miniLmAll.title == "Mini LME")
        #expect(EmbeddingModel.multiQaMiniLm.title == "Multi QA Mini LM")
    }

}
