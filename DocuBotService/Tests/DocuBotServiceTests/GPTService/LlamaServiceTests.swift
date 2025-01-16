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
        let testSubject = LlamaService()

        // Our LLM primes correctly without crashing
        try testSubject.prime(
            with: .mock(
                path: try Self.testModelPath
            ),
            with: .mock()
        )
    }

    @Test("Prime with Missing Model")
    func primeWithMissingModel() {
        let testSubject = LlamaService()

        // Our LLM primes correctly without crashing
        do {
            try testSubject.prime(
                with: .mock(path: "/invalid/path"),
                with: .mock()
            )
            Issue.record("No error was thrown with invalid model path")
        } catch {
            guard let gptError = error as? GPTError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return
            }

            guard case .failedToCreateLLM(let reason) = gptError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return
            }

            #expect(reason == "Cannot load model at path /invalid/path")
        }
    }

    @Test("Prime with Invalid Settings")
    func primeWithInvalidSettings() {
        let testSubject = LlamaService()

        // Our LLM primes correctly without crashing
        do {
            try testSubject.prime(
                with: .mock(path: try Self.testModelPath),
                with: .init(
                    record: .init(model: .mock(contextLength: 2048))
                )
            )
            Issue.record("No error was thrown with invalid model path")
        } catch {
            guard let gptError = error as? GPTError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return
            }

            guard case .failedToCreateLLM(let reason) = gptError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return
            }

            #expect(reason == "Model was trained on 1024 context but tokens 2048 specified")
        }
    }

    @Test("Response Handles Newline Overload")
    func responseHandlesNewlineOverload() async throws {
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
            responses: ["Hello", "\n", "\n", "\n", "World"]
        )

        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        let result = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: nil
        )

        #expect(result == "Hello")
    }

    @Test("OnUpdate is Called")
    func onUpdateIsCalled() async throws {
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
            responses: ["Hello", " ", "world", "!"]
        )

        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        var updates = [String]()
        let onUpdate: @MainActor (String) -> Void = { formattedValue in
            updates.append(formattedValue)
        }

        _ = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: onUpdate
        )

        #expect(updates == ["Hello", " ", "world", "!"])
    }

    @Test("Response Returns Correctly")
    func responseReturnsCorrectly() async throws {
        let mockLlama = try MockLlama(
            modelPath: try Self.testModelPath,
            responses: ["Hello", " ", "world", "!"]
        )

        let testSubject = LlamaService()
        testSubject.llama = mockLlama

        let response = try await testSubject.respond(
            to: "test",
            with: "systemMessage",
            onUpdate: nil
        )

        #expect(response == "Hello world!")
    }

    @Test("Error is thrown when LLM is not primed")
    func errorIsThrownWhenLlmIsNotPrimed() async throws {
        let testSubject = LlamaService()

        do {
            _ = try await testSubject.respond(
                to: "test",
                with: "systemMessage",
                onUpdate: nil
            )
            Issue.record("GPTError should have been thrown.")
        } catch {
            guard let gptError = error as? GPTError else {
                Issue.record("Incorrect error was thrown: \(error)")
                return
            }
            #expect(gptError == .llmNotInitialised)
        }
    }

}
