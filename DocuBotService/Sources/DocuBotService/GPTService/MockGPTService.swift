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

public class MockGPTService: GPTService {

    // MARK: - Service

    public static var key: ServiceKey {
        .gpt
    }

    // MARK: - Types

    public enum PrimeResponse {
        case content
        case error(GPTError)
    }

    public struct PrimeContent {
        public let model: LLMModel
        public let settings: ProjectSettings
    }

    // MARK: - Properties

    public var primeResponse: PrimeResponse!
    public let primePublisher: CurrentValueSubject<PrimeContent?, GPTError>

    public var responseResult: Result<String, GPTError>

    // MARK: - Lifecycle

    init() {
        self.responseResult = .success("")
        self.primePublisher = .init(nil)
    }

    // MARK: - GPTService

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
            fatalError()
        }
    }

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

    public func stop() {
        // Intentionally left blank.
    }

}
