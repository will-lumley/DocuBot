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
    typealias OutputComplete = @MainActor (_ output: String) -> Void

    func respond(
        to query: String,
        from project: Project,
        onUpdate: @escaping OutputUpdated,
        onComplete: @escaping OutputComplete
    ) async throws
}
