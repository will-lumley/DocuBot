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

class MockGPTService: GPTService {

    // MARK: - Service

    static var key: ServiceKey {
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

    // MARK: - Lifecycle

    init() {
        self.primePublisher = .init(nil)
    }

    // MARK: - GPTService

    func prime(
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
        case .none:
            fatalError()
        }
    }

    func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String {
        return ""
    }

}
