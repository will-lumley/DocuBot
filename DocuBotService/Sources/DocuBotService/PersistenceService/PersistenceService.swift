//
//  PersistenceService.swift
//
//
//  Created by William Lumley on 8/12/2023.
//

import Combine
import DocuBotModel
import Foundation

public enum PersistenceError: Error {
    case valueNotFound
}

public protocol PersistenceService: Service {

    func insert(project: Project) async throws -> Project
    func getProjects() -> AnyPublisher<[Project], Error>
    func delete(project: Project) async throws -> Bool

    func insert(settings: ProjectSettings) async throws -> ProjectSettings
    func getProjectSettings(for project: Project) async throws -> ProjectSettings

    func getChats(for project: Project) -> AnyPublisher<[Chat], Error>
    func insert(chat: Chat) async throws -> Chat
    func delete(chat: Chat) async throws -> Bool
    func update(chat: Chat) async throws

    func getMessages(for chat: Chat) -> AnyPublisher<[Message], Error>
    func insert(message: Message) async throws -> Message

}
