//
//  GRDBService+Tests.swift
//  DocuBotServiceTests
//
//  Created by William Lumley on 15/11/2024.
//

import Combine
import DocuBotModel
@testable import DocuBotService
import Foundation
import GRDB
import Testing

struct GRDBServiceTests { // swiftlint:disable:this type_body_length

    // MARK: - Properties

    private let testSubject: GRDBService

    // MARK: - Lifecycle

    init() throws {
        // Initialise the service with an in-memory database
        self.testSubject = GRDBService(
            inMemory: true,
            serviceContainer: .mock
        )
    }

    // MARK: Projects

    @Test("Key Value")
    func keyValue() {
        #expect(GRDBService.key == .persistenceStore)
    }

    @Test("Insert Project")
    func insertProject() async throws {
        // GIVEN we have a project we'd like to commit
        let project = Project.mock()

        // WHEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)

        // THEN we get a valid ID back
        let newID = try #require(insertedProject.id)

        // WHEN we try and fetch the same project back from the DB
        let fetchedProject = try await testSubject.getProject(id: newID)

        // THEN the project we inserted into the DB should match
        // the one we just fetched from the DB
        #expect(insertedProject == fetchedProject)

        // THEN the project we inserted into the DB should match
        // the one we created initially
        #expect(insertedProject.isEqualToIgnoringID(project))
    }

    @Test("Fetch Single Project")
    func fetchSingleProject() async throws {
        // GIVEN we have a project we'd like to commit
        let project = Project.mock()

        // WHEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)

        // THEN we get a valid ID back
        let newID = try #require(insertedProject.id)

        // WHEN we try and fetch the same project back from the DB
        let fetchedProject = try await testSubject.getProject(id: newID)

        // THEN the project we just fetched from the DB should match
        // the one we just created
        #expect(fetchedProject.isEqualToIgnoringID(project))

        // THEN the project we just fetched from the DB should have
        // a new ID attached to it, and that ID should be `1`
        #expect(fetchedProject.id == newID)
        #expect(fetchedProject.id == 1)
    }

    @Test("Fetch Single Project Publisher")
    func fetchSingleProjectPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // GIVEN we have a project we'd like to commit
        let project = Project.mock()

        // WHEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)

        // THEN we get a valid ID back
        let newID = try #require(insertedProject.id)

        // THEN the publisher fires as expected
        await withCheckedContinuation { continuation in
            // WHEN we request a project from the publisher
            testSubject.getProject(id: newID)
                .sink { fetchedProject in
                    // THEN our fetched project and inserted project
                    // are identical
                    #expect(fetchedProject.isEqualToIgnoringID(project))

                    // THEN the project we just fetched from the DB should
                    // have a new ID attached to it, and that ID should be `1`
                    #expect(fetchedProject.id == newID)
                    #expect(fetchedProject.id == 1)

                    // Tell our continuation block that we're done here
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Projects Publisher")
    func fetchAllProjectPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // GIVEN we have two projects we'd like to commit
        let project1 = Project.mock()
        let project2 = Project.mock()

        // WHEN we insert the projects into the database
        let insertedProject1 = try await testSubject.insert(project: project1)
        let insertedProject2 = try await testSubject.insert(project: project2)

        // THEN the publisher fires as expected
        await withCheckedContinuation { continuation in
            // WHEN we request all projects from the publisher
            testSubject.getProjects()
                .replaceError(with: []) // We will crash if there's an error
                .sink { fetchedProjects in
                    let fetchedProject1 = fetchedProjects[0]
                    let fetchedProject2 = fetchedProjects[1]

                    // THEN our fetched projects and the projects
                    // we created initially are identical
                    #expect(fetchedProject1.isEqualToIgnoringID(project1))
                    #expect(fetchedProject2.isEqualToIgnoringID(project2))

                    // THEN our fetched projects and inserted projects
                    // are identical
                    #expect(fetchedProject1 == insertedProject1)
                    #expect(fetchedProject2 == insertedProject2)

                    // THEN the project we just fetched from the DB should
                    // have a new ID attached to it, and that ID should be `1`
                    #expect(fetchedProject1.id == 1)
                    #expect(fetchedProject1.id == insertedProject1.id)

                    // THEN the project we just fetched from the DB should
                    // have a new ID attached to it, and that ID should be `2`
                    #expect(fetchedProject2.id == 2)
                    #expect(fetchedProject2.id == insertedProject2.id)

                    // Tell our continuation block that we're done here
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Delete Project")
    func deleteProject() async throws {
        // GIVEN we have a project we'd like to commit
        let project = Project.mock()

        // WHEN we insert the projects into the database
        let insertedProject = try await testSubject.insert(project: project)

        // THEN we get a valid ID back
        let newID = try #require(insertedProject.id)

        // WHEN we delete the project
        let deleteSuccess = try await testSubject.delete(
            project: insertedProject
        )

        // THEN the deletion is marked as being successful
        #expect(deleteSuccess == true)

        // WHEN we try and pull out the same project that we just deleted
        // THEN we get a `valueNotFound` error thrown.
        await #expect(throws: DocuBotService.PersistenceError.valueNotFound) {
            try await testSubject.getProject(id: newID)
        }
    }

    @Test("Update Project")
    func updateProject() async throws {
        // GIVEN we have a project we'd like to commit
        let project = Project(
            path: "/path/to/project",
            name: "Old Project",
            urlBookmarkData: Data(),
            documentationCheckSum: "abc123",
            exampleQuestions: ["What is this?", "How does it work?"],
            alertStatus: .none,
            needsFullResync: false,
            createdAt: Date(),
            updatedAt: Date()
        )

        // WHEN we insert the project into the database
        let insertedProject = try await testSubject.insert(
            project: project
        )

        // THEN our created project and inserted project are equal
        #expect(project.isEqualToIgnoringID(insertedProject))

        // GIVEN we have a new project that we'd like to overrwrite
        // our most recent entry in the DB
        let newProject = Project(
            id: insertedProject.id,
            path: "/path/to/project",
            name: "Updated Project",
            urlBookmarkData: Data(),
            documentationCheckSum: "xyz789",
            exampleQuestions: ["Why is this?", "Who does it work?"],
            alertStatus: .warning(warning: .isDirty),
            needsFullResync: true,
            createdAt: project.createdAt,
            updatedAt: Date()
        )

        // WHEN we update the project in the DB
        let updatedProject = try await testSubject.update(
            project: newProject
        )

        // THEN our inserted & updated project have an ID, and it is `1`
        let newID = try #require(updatedProject.id)
        #expect(insertedProject.id == updatedProject.id)
        #expect(newID == 1)

        // WHEN we fetch a project from the DB
        let fetchedProject = try await testSubject.getProject(id: newID)

        // THEN it is NOT equal to our old project, and is equal to
        // our new project
        #expect(fetchedProject != project)
        #expect(fetchedProject == newProject)
    }

    // MARK: ProjectSettings

    @Test("Insert Project Settings")
    func insertProjectSettings() async throws {
        // GIVEN we have a project and model we'd like to commit
        let project = Project.mock()
        let model = LLMModel.mock()

        // WHEN we insert it into the DB
        let insertedProject = try await testSubject.insert(project: project)
        let insertedModel = try await testSubject.insert(model: model)

        // WHEN we create a ProjectSettings with our project and model
        let settings = ProjectSettings.mock(
            projectID: try #require(insertedProject.id),
            modelID: try #require(insertedModel.id)
        )

        // WHEN we insert the ProjectSettings into the DB
        let insertedSettings = try await testSubject.insert(
            settings: settings
        )

        // THEN we have an ID from the DB, and the ID is `1`
        let newID = try #require(insertedSettings.id)
        #expect(newID == 1)

        // THEN the InsertedSettings and the Settings we initially
        // created, are equal
        #expect(insertedSettings.isEqualToIgnoringID(settings))
    }

    @Test("Fetch Project Settings")
    func fetchProjectSettings() async throws {
        // GIVEN we have a project and model we'd like to commit
        let project = Project.mock()
        let model = LLMModel.mock()

        // WHEN we insert it into the DB
        let insertedProject = try await testSubject.insert(project: project)
        let insertedModel = try await testSubject.insert(model: model)

        // WHEN we create a ProjectSettings with our project and model
        let settings = ProjectSettings.mock(
            projectID: try #require(insertedProject.id),
            modelID: try #require(insertedModel.id)
        )

        // WHEN we insert the ProjectSettings into the DB
        let insertedSettings = try await testSubject.insert(
            settings: settings
        )

        // THEN we have an ID from the DB, and the ID is `1`
        let newID = try #require(insertedSettings.id)
        #expect(newID == 1)

        // WHEN we try and fetch the same settings back from the DB
        let fetchedSettings = try await testSubject.getProjectSettings(
            for: insertedProject
        )

        // THEN the FetchedSettings and InsertedSettings are equal
        #expect(fetchedSettings == insertedSettings)

        // THEN the initially created Settings matches
        // the FetchedSettings
        #expect(settings.isEqualToIgnoringID(fetchedSettings))
    }

    @Test("Update Project Settings")
    func updateProjectSettings() async throws {
        // GIVEN we have a project and model we'd like to commit
        let project = Project.mock()
        let model1 = LLMModel.mock()
        let model2 = LLMModel.mock()

        // WHEN we insert it into the DB
        let insertedProject = try await testSubject.insert(project: project)
        let insertedModel1 = try await testSubject.insert(model: model1)
        let insertedModel2 = try await testSubject.insert(model: model2)

        // WHEN we create a ProjectSettings with our project and model
        let settings = ProjectSettings.mock(
            projectID: try #require(insertedProject.id),
            modelID: try #require(insertedModel1.id)
        )

        // WHEN we insert the ProjectSettings into the DB
        let insertedSettings = try await testSubject.insert(
            settings: settings
        )

        // THEN we have an ID from the DB, and the ID is `1`
        let newID = try #require(insertedSettings.id)
        #expect(newID == 1)

        // THEN our created project and inserted project are equal
        #expect(settings.isEqualToIgnoringID(insertedSettings))

        // GIVEN we have a new settings that we'd like to overrwrite
        // our most recent entry in the DB
        let updatedSettings = ProjectSettings(
            id: try #require(insertedSettings.id),
            projectID: try #require(insertedProject.id),
            modelID: try #require(insertedModel2.id),
            supportedFormats: [.md, .html],
            language: .english,
            embeddingModel: .multiQaMiniLm,
            similarityMetric: .euclideanDistance,
            seed: 98765,
            topK: 20,
            topP: 0.95,
            contextLength: 1024,
            temperature: 0.5,
            batchSize: 32,
            stopSequence: "###",
            maxTokenCount: 2048,
            systemPrompt: "Explain the topic.",
            strictMode: false,
            createdAt: insertedSettings.createdAt,
            updatedAt: Date()
        )

        // WHEN we overrwrite our settings with the updated settings
        let result = try await testSubject.update(settings: updatedSettings)

        // Ensure the updated settings are correct
        #expect(result == updatedSettings)
    }

    // MARK: Documents

    @Test("Insert Documents")
    func insertDocuments() async throws {
        // GIVEN we have a project we'd like to commit
        let project = Project.mock()

        // GIVEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)
        let projectID = try #require(insertedProject.id)

        // GIVEN we have mock documents to commit
        let documents = [
            Document.mock(projectID: projectID),
            Document.mock(projectID: projectID)
        ]

        // WHEN we insert the documents into the database
        let insertedDocuments = try await testSubject.insert(documents: documents)
        #expect(insertedDocuments.count == 2)

        // WHEN we try and fetch the same documents back from the DB
        let fetchedDocuments = try await testSubject.getDocuments(for: insertedProject)

        // THEN the documents we inserted into the DB should match
        // the one we just fetched from the DB
        #expect(fetchedDocuments.count == 2)
        #expect(fetchedDocuments[0] == insertedDocuments[0])
        #expect(fetchedDocuments[1] == insertedDocuments[1])

        // THEN the documents we inserted into the DB should match
        // the one we created initially
        #expect(insertedDocuments[0].isEqualToIgnoringID(documents[0]))
        #expect(insertedDocuments[1].isEqualToIgnoringID(documents[1]))
    }

    @Test("Fetch Documents by IDs")
    func fetchDocumentsByIDs() async throws {
        // GIVEN we have a project to commit
        let project = Project.mock()

        // GIVEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)
        let projectID = try #require(insertedProject.id)

        // GIVEN we have mock documents to commit
        let documents = [
            Document.mock(projectID: projectID),
            Document.mock(projectID: projectID)
        ]

        // WHEN we insert the documents into the database
        let insertedDocuments = try await testSubject.insert(documents: documents)
        #expect(insertedDocuments.count == 2)

        // GIVEN we have the IDs of the documents we just inserted
        let documentID1 = try #require(insertedDocuments[0].id)
        let documentID2 = try #require(insertedDocuments[1].id)

        // WHEN we fetch the documents from the database via ID
        let fetchedDocument1 = try await testSubject.getDocuments(ids: [documentID1]).first
        let fetchedDocument2 = try await testSubject.getDocuments(ids: [documentID2]).first
        let fetchedDocuments = try await testSubject.getDocuments(ids: [documentID1, documentID2])

        // THEN the FetchedDocuments and InsertedDocuments are equal
        #expect(fetchedDocument1 == insertedDocuments[0])
        #expect(fetchedDocument2 == insertedDocuments[1])
        #expect(fetchedDocuments == insertedDocuments)

        // THEN the initially created Settings matches
        // the FetchedSettings
        #expect(documents[0].isEqualToIgnoringID(insertedDocuments[0]))
        #expect(documents[1].isEqualToIgnoringID(insertedDocuments[1]))
        #expect(documents.count == insertedDocuments.count)
    }

    @Test("Fetch Documents by Project")
    func fetchDocumentsByProject() async throws {
        // GIVEN we have projects to commit
        let project1 = Project.mock()
        let project2 = Project.mock()

        // GIVEN we insert the projects into the database
        let insertedProject1 = try await testSubject.insert(project: project1)
        let projectID1 = try #require(insertedProject1.id)

        let insertedProject2 = try await testSubject.insert(project: project2)
        let projectID2 = try #require(insertedProject2.id)

        // GIVEN we have mock documents to commit
        let documents1 = [
            Document.mock(projectID: projectID1),
            Document.mock(projectID: projectID1)
        ]
        let documents2 = [
            Document.mock(projectID: projectID2),
            Document.mock(projectID: projectID2)
        ]

        // WHEN we insert the documents into the database
        let insertedDocuments1 = try await testSubject.insert(documents: documents1)
        #expect(insertedDocuments1.count == 2)

        let insertedDocuments2 = try await testSubject.insert(documents: documents2)
        #expect(insertedDocuments2.count == 2)

        // WHEN we fetch the documents from the database via Project
        let fetchedDocuments1 = try await testSubject.getDocuments(for: insertedProject1)
        let fetchedDocuments2 = try await testSubject.getDocuments(for: insertedProject2)

        // THEN the FetchedDocuments and InsertedDocuments are equal
        #expect(fetchedDocuments1 == insertedDocuments1)
        #expect(fetchedDocuments1 != insertedDocuments2)

        // THEN the initially created Documents matches
        // the Documents
        #expect(documents1[0].isEqualToIgnoringID(insertedDocuments1[0]))
        #expect(documents1[1].isEqualToIgnoringID(insertedDocuments1[1]))
        #expect(documents1.count == insertedDocuments1.count)
        #expect(documents1.count == 2)

        // THEN our Documents for our Project2 was not included
        #expect(fetchedDocuments2[0] != insertedDocuments1[0])
        #expect(fetchedDocuments2[1] != insertedDocuments1[1])
    }

    @Test("Delete Documents")
    func deleteDocuments() async throws {
        // GIVEN we have a project to commit
        let project = Project.mock()

        // GIVEN we insert the project into the database
        let insertedProject = try await testSubject.insert(project: project)
        let projectID = try #require(insertedProject.id)

        // GIVEN we have mock documents to commit
        let documents = [
            Document.mock(projectID: projectID),
            Document.mock(projectID: projectID)
        ]

        // WHEN we insert the documents into the database
        let insertedDocuments = try await testSubject.insert(documents: documents)
        #expect(insertedDocuments.count == 2)

        // GIVEN we have the IDs of the documents we just inserted
        let documentID1 = try #require(insertedDocuments[0].id)
        let documentID2 = try #require(insertedDocuments[1].id)

        // WHEN we fetch the documents from the database via ID
        let fetchedDocument1 = try await testSubject.getDocuments(ids: [documentID1]).first
        let fetchedDocument2 = try await testSubject.getDocuments(ids: [documentID2]).first
        let fetchedDocuments = try await testSubject.getDocuments(ids: [documentID1, documentID2])

        // THEN the FetchedDocuments and InsertedDocuments are equal
        #expect(fetchedDocument1 == insertedDocuments[0])
        #expect(fetchedDocument2 == insertedDocuments[1])
        #expect(fetchedDocuments == insertedDocuments)

        // WHEN we delete the Documents
        let count = try await testSubject.delete(documents: fetchedDocuments)

        // THEN we have deleted the right amount of documents
        #expect(count == 2)

        // WHEN we try and fetch our previously inserted and deleted
        // documents, we run into an error
        #expect(try await testSubject.getDocuments(ids: [documentID1]) == [])
        #expect(try await testSubject.getDocuments(ids: [documentID2]) == [])
        #expect(try await testSubject.getDocuments(ids: [documentID1, documentID2]) == [])
    }

    // MARK: LLM Model

    @Test("Fetch Model Count Publisher")
    func fetchModelCountPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // GIVEN we have two Models to commit
        let model1 = LLMModel.mock()
        let model2 = LLMModel.mock()

        // WHEN we insert the models into our DB
        _ = try await testSubject.insert(model: model1)
        _ = try await testSubject.insert(model: model2)

        // THEN the publisher fires as expected
        await withCheckedContinuation { continuation in
            // WHEN we request the model count
            testSubject.getModelCount()
                .sink { modelCount in
                    // THEN the model count is 2
                    #expect(modelCount == 2)

                    // Tell our continuation block that we're done here
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Models Publisher")
    func fetchAllModelsPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // GIVEN we have two Models to commit
        let model1 = LLMModel.mock(name: "Model 1")
        let model2 = LLMModel.mock(name: "Model 2")

        // WHEN we insert the models into our DB
        let insertedModel1 = try await testSubject.insert(model: model1)
        let insertedModel2 = try await testSubject.insert(model: model2)

        // THEN the publisher fires as expected
        await withCheckedContinuation { continuation in
            // WHEN we request the models
            testSubject.getModels()
                .replaceError(with: [])
                .sink { fetchedModels in
                    // THEN the model count is 2
                    #expect(fetchedModels.count == 2)

                    let fetchedModel1 = fetchedModels[0]
                    let fetchedModel2 = fetchedModels[1]

                    // THEN our fetched models and the projects
                    // we created initially are identical
                    #expect(fetchedModel1.isEqualToIgnoringID(model1))
                    #expect(fetchedModel2.isEqualToIgnoringID(model2))

                    // THEN our fetched projects and inserted projects
                    // are identical
                    #expect(fetchedModel1 == insertedModel1)
                    #expect(fetchedModel2 == insertedModel2)

                    // THEN the project we just fetched from the DB should
                    // have a new ID attached to it, and that ID should be `1`
                    #expect(fetchedModel1.id == 1)
                    #expect(fetchedModel1.id == insertedModel1.id)

                    // THEN the project we just fetched from the DB should
                    // have a new ID attached to it, and that ID should be `2`
                    #expect(fetchedModel2.id == 2)
                    #expect(fetchedModel2.id == insertedModel2.id)

                    // Tell our continuation block that we're done here
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Models")
    func fetchAllModels() async throws {
        // GIVEN we have two Models to commit
        let model1 = LLMModel.mock(name: "Model 1")
        let model2 = LLMModel.mock(name: "Model 2")

        // WHEN we insert the models into our DB
        let insertedModel1 = try await testSubject.insert(model: model1)
        let insertedModel2 = try await testSubject.insert(model: model2)

        // WHEN we request the models
        let fetchedModels = try await testSubject.getModels()

        // THEN the model count is 2
        #expect(fetchedModels.count == 2)

        let fetchedModel1 = fetchedModels[0]
        let fetchedModel2 = fetchedModels[1]

        // THEN our fetched models and the projects
        // we created initially are identical
        #expect(fetchedModel1.isEqualToIgnoringID(model1))
        #expect(fetchedModel2.isEqualToIgnoringID(model2))

        // THEN our fetched projects and inserted projects
        // are identical
        #expect(fetchedModel1 == insertedModel1)
        #expect(fetchedModel2 == insertedModel2)

        // THEN the project we just fetched from the DB should
        // have a new ID attached to it, and that ID should be `1`
        #expect(fetchedModel1.id == 1)
        #expect(fetchedModel1.id == insertedModel1.id)

        // THEN the project we just fetched from the DB should
        // have a new ID attached to it, and that ID should be `2`
        #expect(fetchedModel2.id == 2)
        #expect(fetchedModel2.id == insertedModel2.id)
    }

    @Test("Insert Model")
    func insertModel() async throws {
        // GIVEN we have two Models to commit
        let model1 = LLMModel.mock(name: "Model 1")
        let model2 = LLMModel.mock(name: "Model 2")

        // WHEN we insert the models into our DB
        let insertedModel1 = try await testSubject.insert(model: model1)
        let insertedModel2 = try await testSubject.insert(model: model2)

        let newID1 = try #require(insertedModel1.id)
        let newID2 = try #require(insertedModel2.id)

        // WHEN we request the model
        let fetchedModel1 = try await testSubject.getModel(id: newID1)
        let fetchedModel2 = try await testSubject.getModel(id: newID2)

        // THEN our fetched models and the projects
        // we created initially are identical
        #expect(fetchedModel1.isEqualToIgnoringID(model1))
        #expect(fetchedModel2.isEqualToIgnoringID(model2))

        // THEN our fetched projects and inserted projects
        // are identical
        #expect(fetchedModel1 == insertedModel1)
        #expect(fetchedModel2 == insertedModel2)

        // THEN the project we just fetched from the DB should
        // have a new ID attached to it, and that ID should be `1`
        #expect(fetchedModel1.id == 1)
        #expect(fetchedModel1.id == insertedModel1.id)

        // THEN the project we just fetched from the DB should
        // have a new ID attached to it, and that ID should be `2`
        #expect(fetchedModel2.id == 2)
        #expect(fetchedModel2.id == insertedModel2.id)
    }

    @Test("Fetch Model by ID")
    func fetchModelByID() async throws {
        // GIVEN we have a project to commit
        let model = LLMModel.mock()

        // GIVEN we insert the project into the database
        let insertedModel = try await testSubject.insert(model: model)
        let modelID = try #require(insertedModel.id)

        // WHEN we fetch the model from the database via ID
        let fetchedModel = try await testSubject.getModel(id: modelID)

        // THEN the FetchedModel and InsertedModel are equal
        #expect(fetchedModel == insertedModel)

        // THEN the initially created model matches
        // the FetchedModel
        #expect(fetchedModel.isEqualToIgnoringID(model))
    }

    @Test("Update Model")
    func updateModel() async throws {
        // GIVEN we have a model we'd like to commit
        let model = LLMModel(
            name: "Model 1",
            path: "/path/to/model",
            size: 5000,
            createdAt: .now,
            updatedAt: .now
        )

        // WHEN we insert the model into the database
        let insertedModel = try await testSubject.insert(
            model: model
        )

        // THEN our created model and inserted model are equal
        #expect(model.isEqualToIgnoringID(insertedModel))

        // GIVEN we have a new model that we'd like to overrwrite
        // our most recent entry in the DB
        let newModel = LLMModel(
            id: insertedModel.id,
            name: "Model 2",
            path: "/new/path/to/model",
            size: 6000,
            createdAt: .now,
            updatedAt: .now
        )

        // WHEN we update the model in the DB
        let updatedModel = try await testSubject.update(
            model: newModel
        )

        // THEN our inserted & updated model have an ID, and it is `1`
        let newID = try #require(updatedModel.id)
        #expect(insertedModel.id == updatedModel.id)
        #expect(newID == 1)

        // WHEN we fetch a project from the DB
        let fetchedModel = try await testSubject.getModel(id: newID)

        // THEN it is NOT equal to our old project, and is equal to
        // our new project
        #expect(fetchedModel != model)
        #expect(fetchedModel == newModel)
    }

    @Test("Delete Model")
    func deleteModel() async throws {
        // GIVEN we have a project to commit
        let model = LLMModel.mock()

        // GIVEN we insert the project into the database
        let insertedModel = try await testSubject.insert(model: model)
        let modelID = try #require(insertedModel.id)

        // WHEN we delete the model
        let deleteSuccess = try await testSubject.delete(
            model: insertedModel,
            deleteModelOnDisk: false
        )

        // THEN the deletion is marked as being successful
        #expect(deleteSuccess == true)

        // WHEN we try and pull out the same model that we just deleted
        // THEN we get a `valueNotFound` error thrown.
        await #expect(throws: DocuBotService.PersistenceError.valueNotFound) {
            try await testSubject.getModel(id: modelID)
        }
    }

} // swiftlint:disable:this file_length
