//
//  GPTService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import DocuBotModel
import Foundation

public protocol GPTService: Service {

    typealias OutputUpdated = @MainActor (_ delta: String) -> Void

    func prime(
        with model: LLMModel,
        with settings: ProjectSettings
    ) throws(GPTError)

    func respond(
        to query: String,
        with systemMessage: String,
        onUpdate: OutputUpdated?
    ) async throws -> String
}
