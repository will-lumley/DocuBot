//
//  LlamaServiceTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import DocuBotModel
@testable import DocuBotService
import Foundation
import Testing

struct LLMSwiftServiceTests {

    // MARK: - Properties

    /// This will fetch a very intentionally small model that is garbage, but does the
    /// job for testing purposes.
    ///
    /// - Returns: The file path for a test model
    ///
    static var testModelPath: String {
        get throws {
            try #require(
                Bundle.module.path(
                    forResource: "distilgpt2Q4_0",
                    ofType: "gguf"
                )
            )
        }
    }

    // MARK: - Tests

    @Test("Prime")
    func prime() throws {
        // GIVEN we have the LlamaService
        // WHEN we instantiate it
        let testSubject = LLMSwiftService()

        // THEN we can prime it throwing an error
        try testSubject.prime(
            with: .mock(
                path: try Self.testModelPath
            ),
            with: .mock()
        )
    }

    /*
    @Test("Prime with Missing Model")
    func primeWithMissingModel() {
        // GIVEN we have the LlamaService
        let testSubject = LlamaService()

        #expect(throws: GPTError.noModel(modelName: "Random Model")) {
            // WHEN we prime the LLM with an invalid model path
            try testSubject.prime(
                with: .mock(
                    name: "Random Model",
                    path: "/invalid/path"
                ),
                with: .mock()
            )
        }
    }

    @Test("OnUpdate is Called")
    func onUpdateIsCalled() async throws {
        // We will create a pretend LLM here that is pre-set
        // to return a determined series of responses.
        let mockLlama = try MockLLM(
            responses: ["Hello", " ", "world", "!"]
        )

        // GIVEN we have the LlamaService
        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        // Here we're just going to setup and listen to our updates
        var updates = [String]()
        let onUpdate: @MainActor (String) -> Void = { formattedValue in
            updates.append(formattedValue)
        }

        // WHEN we query for a response
        _ = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: onUpdate
        )

        // THEN our onUpdate correctly received the updates
        #expect(updates == ["Hello", " ", "world", "!"])
    }

    @Test("Response Returns Correctly")
    func responseReturnsCorrectly() async throws {
        // We will create a pretend LLM here that is pre-set
        // to return a determined series of responses.
        let mockLlama = try MockLLM(
            responses: ["Hello", " ", "world", "!"]
        )

        // GIVEN we have the LlamaService
        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        // WHEN we query for a response
        let response = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: nil
        )

        // THEN our response is the finalised chain of the pre-set response chains
        #expect(response == "Hello world!")
    }
     */

    @Test("Error is thrown when LLM is not primed")
    func errorIsThrownWhenLlmIsNotPrimed() async throws {
        // GIVEN we have the LlamaService
        let testSubject = LLMSwiftService()

        await #expect(throws: GPTError.llmNotInitialised) {
            // WHEN we query for a response without priming
            // THEN we have the correct error thrown
            try await testSubject.respond(
                to: "test",
                with: "systemMessage",
                onUpdate: nil
            )
        }
    }

}
