//
//  ModelCellModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

@Suite("ModelCellModelTests", .tags(.view))
struct ModelCellModelTests {

    @Test("Title")
    func title() {
        let mock = LLMModel.mock(
            name: "Cool Model Name"
        )
        let testSubject = ModelCellModel(model: mock)
        #expect(testSubject.title == "Cool Model Name")
    }

    @Test("Subtitle")
    func subtitle() {
        let mock = LLMModel.mock(
            size: 10241024
        )
        let testSubject = ModelCellModel(model: mock)
        #expect(testSubject.subtitle == "0.01 GB")
    }

}
