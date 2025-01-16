//
//  MockGPTService.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

import Combine
import DocuBotModel
import DocuBotToolbox
import Foundation

/// A mock implementation of the `GPTService` protocol for testing purposes.
///
/// The `MockGPTService` provides a configurable and predictable implementation of
/// the `GPTService` protocol, enabling the simulation of responses, errors,
/// and real-time updates without interacting with an actual AI backend.
public final class MockGPTService: GPTService {

    // MARK: - Service

    /// The unique key identifying the GPT service.
    ///
    /// This key is used to register the `MockGPTService` within a service container.
    public static var key: ServiceKey {
        .gpt
    }

    // MARK: - Types

    /// Represents the possible outcomes of the `prime` operation.
    public enum PrimeResponse {
        /// Indicates successful priming with content.
        case content

        /// Indicates an error occurred during priming.
        case error(GPTError)
    }

    /// Represents the content used to prime the GPT service.
    public struct PrimeContent {
        /// The model used for priming.
        public let model: LLMModel

        /// The settings used for priming.
        public let settings: ProjectSettings
    }

    // MARK: - Properties

    /// Configurable response for the `prime` operation.
    ///
    /// Determines whether the `prime` method will succeed or throw an error.
    public var primeResponse: PrimeResponse!

    /// A publisher that emits updates when the service is primed.
    ///
    /// This publisher sends the priming content or a failure event when an error occurs.
    public let primePublisher: CurrentValueSubject<PrimeContent?, GPTError>

    /// Configurable result for the `respond` method.
    ///
    /// Determines whether the `respond` method will return a string or throw an error.
    public var responseResult: Result<String, GPTError>

    // MARK: - Lifecycle

    /// Creates a new instance of `MockGPTService`.
    ///
    /// This initializer sets up default values for the response results and the priming publisher.
    public init() {
        self.responseResult = .success("")
        self.primePublisher = .init(nil)
    }

    // MARK: - GPTService

    /// Simulates priming the service with a model and settings.
    ///
    /// The behavior of this method is controlled by the `primeResponse` property.
    ///
    /// - Parameters:
    ///   - model: The `LLMModel` to use for priming.
    ///   - settings: The `ProjectSettings` to use for priming.
    /// - Throws: A `GPTError` if the `primeResponse` is configured to simulate an error.
    public func prime(
        with model: LLMModel,
        with settings: ProjectSettings
    ) throws(GPTError) {
        switch self.primeResponse {
        case .content:
            self.primePublisher.send(
                .init(model: model, settings: settings)
            )
        case .error(let error):
            self.primePublisher.send(completion: .failure(error))
            throw error
        case .none:
            fatalError("`primeResponse` is not set.")
        }
    }

    /// Simulates generating a response to a query with optional real-time updates.
    ///
    /// The behavior of this method is controlled by the `responseResult` property.
    ///
    /// - Parameters:
    ///   - query: The user's input query.
    ///   - systemMessage: A system-level prompt providing context or instructions for the response.
    ///   - onUpdate: An optional closure that provides incremental updates to the response text.
    /// - Returns: The full response string if the operation is successful.
    /// - Throws: A `GPTError` if the `responseResult` is configured to simulate an error.
    public func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String {
        switch self.responseResult {
        case .success(let string):
            for char in string {
                try await Task.sleep(for: .seconds(1))
                await onUpdate?(String(char))
            }
            return string
        case .failure(let failure):
            throw failure
        }
    }

    /// Simulates stopping the response generation process.
    ///
    /// This method is intentionally left blank as it serves only as a placeholder.
    public func stop() {
        // Intentionally left blank.
    }

}
