//
//  PersistenceService.swift
//
//
//  Created by William Lumley on 8/12/2023.
//

import Combine
import DocuBotModel
import Foundation

public enum PersistenceError: LocalizedError {
    case valueNotFound

    public var errorDescription: String? {
        switch self {
        case .valueNotFound:
            return L10n.Error.Persistence.valueNotFound
        }
    }
}

public protocol PersistenceService: Service {

    func insert(project: Project) async throws -> Project
    func getProject(id: Int64) async throws -> Project
    func getProject(id: Int64) -> AnyPublisher<Project, Never>
    func getProjects() -> AnyPublisher<[Project], Error>
    func delete(project: Project) async throws -> Bool
    func update(project: Project) async throws -> Project

    func insert(settings: ProjectSettings) async throws -> ProjectSettings
    func getProjectSettings(for project: Project) async throws -> ProjectSettings
    func update(settings: ProjectSettings) async throws -> ProjectSettings

    func getDocuments(ids: [Int64]) async throws -> [Document]
    func getDocuments(for project: Project) async throws -> [Document]
    func insert(documents: [Document]) async throws -> [Document]
    func delete(documents: [Document]) async throws -> Int

    func getModelCount() -> AnyPublisher<Int?, Never>
    func getModels() -> AnyPublisher<[Model], Error>
    func getModels() async throws -> [Model]
    func getModel(id: Int64) async throws -> Model
    func insert(model: Model) async throws -> Model
    func update(model: Model) async throws -> Model
    func delete(model: Model) async throws -> Bool

}
