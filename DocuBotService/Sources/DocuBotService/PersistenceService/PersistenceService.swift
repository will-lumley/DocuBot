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

    func insert(project: Project) async throws
    func getProjects() -> AnyPublisher<[Project], Error>
    func delete(project: Project) async throws -> Bool

    func getChats(for project: Project) -> AnyPublisher<[Chat], Error>
    func insert(chat: Chat) async throws
    func delete(chat: Chat) async throws -> Bool

    func getMessages(for chat: Chat) -> AnyPublisher<[Message], Error>

}
