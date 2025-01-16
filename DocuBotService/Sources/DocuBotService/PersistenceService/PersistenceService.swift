//
//  PersistenceService.swift
//
//
//  Created by William Lumley on 8/12/2023.
//

import Combine
import DocuBotModel
import Foundation

public protocol PersistenceService: Service {

    func getProjects() -> AnyPublisher<[Project], Error>
    func delete(project: Project) async throws -> Bool

    func getChats(for project: Project) -> AnyPublisher<[Chat], Error>
    func getMessages(for chat: Chat) -> AnyPublisher<[Message], Error>

}
