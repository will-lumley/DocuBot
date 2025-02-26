//
//  MockLlama.swift
//  DocuBotService
//
//  Created by William Lumley on 26/2/2025.
//


//
//  MockLlama.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Foundation
import Testing

class MockLlama: SwiftLlama, @unchecked Sendable {

    // MARK: - Properties

    var responses: [String] = []

    // MARK: - Lifecycle

    init(modelPath: String, responses: [String]) throws {
        self.responses = responses
        try super.init(
            modelPath: modelPath,
            modelConfiguration: .init()
        )
    }

    // MARK: - Functions

    override func start(
        for prompt: Prompt,
        sessionSupport: Bool = false
    ) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            for response in self.responses {
                continuation.yield(response)
            }
            continuation.finish()
        }
    }

}
