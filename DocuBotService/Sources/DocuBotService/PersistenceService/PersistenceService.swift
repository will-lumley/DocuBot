//
//  PersistenceService.swift
//
//
//  Created by William Lumley on 8/12/2023.
//

import Combine
import DocuBotModel
import Foundation

/// A protocol defining the requirements for a persistence service.
///
/// The `PersistenceService` protocol provides methods to manage and interact with
/// persistent storage for projects, settings, documents, and models.
public protocol PersistenceService: Service {

    // MARK: - Project Management

    /// Inserts a project into the persistence layer.
    ///
    /// - Parameter project: The project to insert.
    /// - Returns: The inserted `Project` with updated attributes (e.g., ID).
    /// - Throws: An error if the insertion fails.
    func insert(project: Project) async throws -> Project

    /// Retrieves a project by its identifier.
    ///
    /// - Parameter id: The identifier of the project.
    /// - Returns: The matching `Project`.
    /// - Throws: An error if the project is not found or retrieval fails.
    func getProject(id: Int64) async throws -> Project

    /// Publishes updates to a project identified by its identifier.
    ///
    /// - Parameter id: The identifier of the project.
    /// - Returns: A publisher emitting updates to the `Project`.
    func getProject(id: Int64) -> AnyPublisher<Project, Never>

    /// Publishes a list of all projects.
    ///
    /// - Returns: A publisher emitting an array of `Project` objects or an error.
    func getProjects() -> AnyPublisher<[Project], Error>

    /// Retrieves all projects asynchronously.
    ///
    /// - Returns: An array of all `Project` objects.
    /// - Throws: An error if retrieval fails.
    func getProjects() async throws -> [Project]

    /// Deletes a project from the persistence layer.
    ///
    /// - Parameter project: The project to delete.
    /// - Returns: `true` if the project was successfully deleted; otherwise, `false`.
    /// - Throws: An error if deletion fails.
    func delete(project: Project) async throws -> Bool

    /// Updates an existing project in the persistence layer.
    ///
    /// - Parameter project: The project with updated attributes.
    /// - Returns: The updated `Project`.
    /// - Throws: An error if the update fails.
    func update(project: Project) async throws -> Project

    // MARK: - Project Settings Management

    /// Inserts settings for a project into the persistence layer.
    ///
    /// - Parameter settings: The project settings to insert.
    /// - Returns: The inserted `ProjectSettings`.
    /// - Throws: An error if insertion fails.
    func insert(settings: ProjectSettings) async throws -> ProjectSettings

    /// Retrieves settings for a specific project asynchronously.
    ///
    /// - Parameter project: The project for which to retrieve settings.
    /// - Returns: The matching `ProjectSettings`.
    /// - Throws: An error if retrieval fails.
    func getProjectSettings(for project: Project) async throws -> ProjectSettings

    /// Publishes updates to settings for a specific project.
    ///
    /// - Parameter project: The project for which to publish settings updates.
    /// - Returns: A publisher emitting `ProjectSettings`.
    func getProjectSettings(for project: Project) -> AnyPublisher<ProjectSettings, Never>

    /// Updates settings for a specific project in the persistence layer.
    ///
    /// - Parameter settings: The updated project settings.
    /// - Returns: The updated `ProjectSettings`.
    /// - Throws: An error if the update fails.
    func update(settings: ProjectSettings) async throws -> ProjectSettings

    // MARK: - Document Management

    /// Retrieves documents by their identifiers.
    ///
    /// - Parameter ids: The identifiers of the documents to retrieve.
    /// - Returns: An array of matching `Document` objects.
    /// - Throws: An error if retrieval fails.
    func getDocuments(ids: [Int64]) async throws -> [Document]

    /// Retrieves all documents associated with a specific project.
    ///
    /// - Parameter project: The project for which to retrieve documents.
    /// - Returns: An array of matching `Document` objects.
    /// - Throws: An error if retrieval fails.
    func getDocuments(for project: Project) async throws -> [Document]

    /// Inserts an array of documents into the persistence layer.
    ///
    /// - Parameter documents: The documents to insert.
    /// - Returns: An array of inserted `Document` objects.
    /// - Throws: An error if insertion fails.
    func insert(documents: [Document]) async throws -> [Document]

    /// Deletes an array of documents from the persistence layer.
    ///
    /// - Parameter documents: The documents to delete.
    /// - Returns: The number of documents successfully deleted.
    /// - Throws: An error if deletion fails.
    func delete(documents: [Document]) async throws -> Int

    // MARK: - Model Management

    /// Publishes the count of models in the persistence layer.
    ///
    /// - Returns: A publisher emitting the number of models or `nil` if unavailable.
    func getModelCount() -> AnyPublisher<Int?, Never>

    /// Publishes all models in the persistence layer.
    ///
    /// - Returns: A publisher emitting an array of `LLMModel` objects or an error.
    func getModels() -> AnyPublisher<[LLMModel], Error>

    /// Retrieves all models asynchronously.
    ///
    /// - Returns: An array of all `LLMModel` objects.
    /// - Throws: An error if retrieval fails.
    func getModels() async throws -> [LLMModel]

    /// Retrieves a model by its identifier.
    ///
    /// - Parameter id: The identifier of the model.
    /// - Returns: The matching `LLMModel`.
    /// - Throws: An error if the model is not found or retrieval fails.
    func getModel(id: Int64) async throws -> LLMModel

    /// Inserts a model into the persistence layer.
    ///
    /// - Parameter model: The model to insert.
    /// - Returns: The inserted `LLMModel`.
    /// - Throws: An error if insertion fails.
    func insert(model: LLMModel) async throws -> LLMModel

    /// Updates an existing model in the persistence layer.
    ///
    /// - Parameter model: The model with updated attributes.
    /// - Returns: The updated `LLMModel`.
    /// - Throws: An error if the update fails.
    func update(model: LLMModel) async throws -> LLMModel

    /// Deletes a model from the persistence layer.
    ///
    /// - Parameters:
    ///   - model: The model to delete.
    ///   - deleteModelOnDisk: A Boolean indicating whether to delete the model from disk as well.
    /// - Returns: `true` if the model was successfully deleted; otherwise, `false`.
    /// - Throws: An error if deletion fails.
    func delete(model: LLMModel, deleteModelOnDisk: Bool) async throws -> Bool

}
