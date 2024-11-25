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

struct LlamaServiceTests {

    // MARK: - Properties

    /// This will fetch a very intentionally small model that is garbage, but does the
    /// job for testing purposes.
    ///
    /// - returns: The file path for a test model
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
        let testSubject = LlamaService()

        // THEN we can prime it throwing an error
        try testSubject.prime(
            with: .mock(
                path: try Self.testModelPath
            ),
            with: .mock()
        )
    }

    @Test("Prime with Missing Model")
    func primeWithMissingModel() {
        // GIVEN we have the LlamaService
        let testSubject = LlamaService()

        #expect {
            // WHEN we prime the LLM with an invalid model path
            try testSubject.prime(
                with: .mock(path: "/invalid/path"),
                with: .mock()
            )
        } throws: { error in
            // THEN the error thrown is a `GPTError`
            guard let gptError = error as? GPTError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return false
            }

            // THEN the type of `GPTError` is `failedToCreateLLM`
            guard case .failedToCreateLLM(let reason) = gptError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return false
            }

            // THEN the reason given is correctly stated
            return reason == "Cannot load model at path /invalid/path"
        }
    }

    @Test("Prime with Invalid Settings")
    func primeWithInvalidSettings() {
        // GIVEN we have the LlamaService
        let testSubject = LlamaService()

        #expect {
            // WHEN we prime the LLM with an context length
            try testSubject.prime(
                with: .mock(path: try Self.testModelPath),
                with: .init(
                    record: .init(model: .mock(contextLength: 2048))
                )
            )
        } throws: { error in
            // THEN the error thrown is a `GPTError`
            guard let gptError = error as? GPTError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return false
            }

            // THEN the type of `GPTError` is `failedToCreateLLM`
            guard case .failedToCreateLLM(let reason) = gptError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return false
            }

            // THEN the reason given is correctly stated
            return reason == "Model was trained on 1024 context but tokens 2048 specified"
        }
    }

    @Test("Response Handles Newline Overload")
    func responseHandlesNewlineOverload() async throws {
        // We will create a pretend LLM here that is pre-set
        // to return a determined series of responses.
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
            responses: ["Hello", "\n", "\n", "\n", "World"]
        )

        // GIVEN we have the LlamaService
        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        // WHEN we query for a response
        let result = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: nil
        )

        // THEN we only get the "Hello" as three newlines kills the response chain
        #expect(result == "Hello")
    }

    @Test("OnUpdate is Called")
    func onUpdateIsCalled() async throws {
        // We will create a pretend LLM here that is pre-set
        // to return a determined series of responses.
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
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
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
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

    @Test("Error is thrown when LLM is not primed")
    func errorIsThrownWhenLlmIsNotPrimed() async throws {
        // GIVEN we have the LlamaService
        let testSubject = LlamaService()

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
