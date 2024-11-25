//
//  LLMModelTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Testing

struct LLMModelTests {

    @Test("ModelError Description")
    func modelErrorDescription() {
        // GIVEN we have a missing error
        let error = LLMModel.ModelError.missingID

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Model.missingID)
    }

    @Test("ModelFetchError Description")
    func modelFetchErrorDescription() {
        // GIVEN we have a failedConversion error
        let error = LLMModel.ModelFetchError.binaryMissing

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Model.binaryMissing)
    }

}
