//
//  GPTService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import Foundation
import DocuBotModel

public protocol GPTService: Service {

    typealias OutputUpdated = (_ delta: String) -> Void
    typealias OutputComplete = (_ output: String) -> Void

    func respond(
        to query: String,
        from chat: DocuBotModel.Chat,
        from project: Project,
        onUpdate: @escaping OutputUpdated,
        onComplete: @escaping OutputComplete
    ) async
}
