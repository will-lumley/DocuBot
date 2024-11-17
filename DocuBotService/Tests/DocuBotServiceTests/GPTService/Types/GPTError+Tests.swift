//
//  GPTError+Tests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Testing

struct GPTErrorTests {

    @Test("Error Description")
    func errorDescription() {
        #expect(GPTError.llmNotInitialised.description == "LLM Instance is not initialised.")
        #expect(GPTError.failedToCreateLLMDecodingError.description == "Failed to create LLM due to a decoding error.")

        // swiftlint:disable:next line_length
        #expect(GPTError.noModel(modelName: "model-name").description == "Failed to find the selected model, model-name.")

        // swiftlint:disable:next line_length
        #expect(GPTError.failedToCreateLLM(reason: "Just can't be bothered").description == "Failed to create LLM. Just can't be bothered.")
    }

    @Test("Equality")
    func equality() {
        // Test for `.llmNotInitialised` equality
        #expect(GPTError.llmNotInitialised == .llmNotInitialised)
        #expect(GPTError.llmNotInitialised != .failedToCreateLLM(reason: ""))
        #expect(GPTError.llmNotInitialised != .failedToCreateLLMDecodingError)
        #expect(GPTError.llmNotInitialised != .noModel(modelName: ""))

        // Test for `.failedToCreateLLMDecodingError` equality
        #expect(GPTError.failedToCreateLLMDecodingError != .llmNotInitialised)
        #expect(GPTError.failedToCreateLLMDecodingError != .failedToCreateLLM(reason: ""))
        #expect(GPTError.failedToCreateLLMDecodingError == .failedToCreateLLMDecodingError)
        #expect(GPTError.failedToCreateLLMDecodingError != .noModel(modelName: ""))

        // Test for `.noModel` equality
        #expect(GPTError.noModel(modelName: "foo") != .noModel(modelName: "bar"))
        #expect(GPTError.noModel(modelName: "foo") == .noModel(modelName: "foo"))
        #expect(GPTError.noModel(modelName: "") != .failedToCreateLLM(reason: ""))
        #expect(GPTError.noModel(modelName: "") != .llmNotInitialised)
        #expect(GPTError.noModel(modelName: "") != .failedToCreateLLMDecodingError)

        // Test for `.failedToCreateLLM` equality
        #expect(GPTError.failedToCreateLLM(reason: "foo") != .failedToCreateLLM(reason: "bar"))
        #expect(GPTError.failedToCreateLLM(reason: "foo") == .failedToCreateLLM(reason: "foo"))
        #expect(GPTError.failedToCreateLLM(reason: "") != .noModel(modelName: ""))
        #expect(GPTError.failedToCreateLLM(reason: "") != .llmNotInitialised)
        #expect(GPTError.failedToCreateLLM(reason: "") != .failedToCreateLLMDecodingError)
    }

}
