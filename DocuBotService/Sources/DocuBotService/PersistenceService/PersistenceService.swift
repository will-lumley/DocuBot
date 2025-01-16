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
    func getChats(for project: ProjectRecord) -> AnyPublisher<[Chat], Error>
    func getMessages(for chat: ChatRecord) -> AnyPublisher<[Message], Error>

}
