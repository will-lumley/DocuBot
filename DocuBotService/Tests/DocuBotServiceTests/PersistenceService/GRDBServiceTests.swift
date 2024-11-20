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

struct GRDBServiceTests {

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

        // Fetch the settings for the project
        let fetchedSettings = try await testSubject.getProjectSettings(
            for: project
        )

        // Ensure the FetchedSettings and InsertedSettings are equal
        #expect(fetchedSettings == insertedSettings)

        // Ensure the initially created Settings matches
        // the FetchedSettings
        #expect(settings == fetchedSettings)
    }

    @Test("Update Project Settings")
    func updateProjectSettings() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Create 2 mock models and insert them
        let model1 = try await testSubject.insert(model: LLMModel.mock())
        _ = try await testSubject.insert(model: LLMModel.mock())

        // Create a mock project settings object
        let initialSettings = ProjectSettings.mock(
            projectID: try #require(project.id),
            modelID: try #require(model1.id)
        )

        // Insert the settings
        let insertedSettings = try await testSubject.insert(settings: initialSettings)

        // Update the settings
        let updatedSettings = ProjectSettings(
            id: try #require(insertedSettings.id),
            projectID: try #require(project.id),
            modelID: 2,
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
            createdAt: initialSettings.createdAt,
            updatedAt: Date()
        )

        let result = try await testSubject.update(settings: updatedSettings)

        // Ensure the updated settings are correct
        #expect(result.id == updatedSettings.id)
        #expect(result.projectID == updatedSettings.projectID)
        #expect(result.modelID == updatedSettings.modelID)
        #expect(result.supportedFormats == updatedSettings.supportedFormats)
        #expect(result.language == updatedSettings.language)
        #expect(result.embeddingModel == updatedSettings.embeddingModel)
        #expect(result.similarityMetric == updatedSettings.similarityMetric)
        #expect(result.seed == updatedSettings.seed)
        #expect(result.topK == updatedSettings.topK)
        #expect(result.topP == updatedSettings.topP)
        #expect(result.contextLength == updatedSettings.contextLength)
        #expect(result.temperature == updatedSettings.temperature)
        #expect(result.batchSize == updatedSettings.batchSize)
        #expect(result.stopSequence == updatedSettings.stopSequence)
        #expect(result.maxTokenCount == updatedSettings.maxTokenCount)
        #expect(result.systemPrompt == updatedSettings.systemPrompt)
        #expect(result.strictMode == updatedSettings.strictMode)
        #expect(Int(result.createdAt.timeIntervalSince1970) == Int(initialSettings.createdAt.timeIntervalSince1970))
        #expect(Int(result.updatedAt.timeIntervalSince1970) == Int(updatedSettings.updatedAt.timeIntervalSince1970))
    }

    // MARK: Documents

    @Test("Insert Documents")
    func insertDocuments() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Create mock documents
        let documents = [
            Document.mock(projectID: try #require(project.id)),
            Document.mock(projectID: try #require(project.id))
        ]

        // Insert the documents
        let insertedDocuments = try await testSubject.insert(documents: documents)
        #expect(insertedDocuments.count == 2)

        // Verify the properties of the inserted documents
        for (index, document) in insertedDocuments.enumerated() {
            let projectID = try #require(project.id)
            #expect(document.projectID == projectID)
            #expect(document.url == documents[index].url)
            #expect(document.fileFormat == documents[index].fileFormat)
            #expect(document.content == documents[index].content)
            #expect(document.checksum == documents[index].checksum)
            #expect(document.embeddings == documents[index].embeddings)
            #expect(
                Int(document.createdAt.timeIntervalSince1970) == Int(documents[index].createdAt.timeIntervalSince1970)
            )
            #expect(
                Int(document.updatedAt.timeIntervalSince1970) == Int(documents[index].updatedAt.timeIntervalSince1970)
            )
        }
    }

    @Test("Fetch Documents by IDs")
    func fetchDocumentsByIDs() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Insert mock documents
        let documents = try await testSubject.insert(documents: [
            Document.mock(projectID: try #require(project.id)),
            Document.mock(projectID: try #require(project.id))
        ])

        let documentIDs = documents.compactMap(\.id)
        #expect(documentIDs.count == 2)

        // Fetch documents by IDs
        let fetchedDocuments = try await testSubject.getDocuments(ids: documentIDs)
        #expect(fetchedDocuments.count == documents.count)

        // Verify the fetched documents match the inserted ones
        for (inserted, fetched) in zip(documents, fetchedDocuments) {
            #expect(fetched.id == inserted.id)
            #expect(fetched.projectID == inserted.projectID)
            #expect(fetched.url == inserted.url)
            #expect(fetched.fileFormat == inserted.fileFormat)
            #expect(fetched.content == inserted.content)
            #expect(fetched.checksum == inserted.checksum)
            #expect(fetched.embeddings == inserted.embeddings)
            #expect(Int(fetched.createdAt.timeIntervalSince1970) == Int(inserted.createdAt.timeIntervalSince1970))
            #expect(Int(fetched.updatedAt.timeIntervalSince1970) == Int(inserted.updatedAt.timeIntervalSince1970))
        }
    }

    @Test("Fetch Documents by Project")
    func fetchDocumentsByProject() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Insert mock documents
        let documents = try await testSubject.insert(documents: [
            Document.mock(projectID: try #require(project.id)),
            Document.mock(projectID: try #require(project.id))
        ])

        // Fetch documents for the project
        let fetchedDocuments = try await testSubject.getDocuments(for: project)
        #expect(fetchedDocuments.count == documents.count)

        // Verify the fetched documents match the inserted ones
        for (inserted, fetched) in zip(documents, fetchedDocuments) {
            #expect(fetched.id == inserted.id)
            #expect(fetched.projectID == inserted.projectID)
            #expect(fetched.url == inserted.url)
            #expect(fetched.fileFormat == inserted.fileFormat)
            #expect(fetched.content == inserted.content)
            #expect(fetched.checksum == inserted.checksum)
            #expect(fetched.embeddings == inserted.embeddings)
            #expect(Int(fetched.createdAt.timeIntervalSince1970) == Int(inserted.createdAt.timeIntervalSince1970))
            #expect(Int(fetched.updatedAt.timeIntervalSince1970) == Int(inserted.updatedAt.timeIntervalSince1970))
        }
    }

    @Test("Delete Documents")
    func deleteDocuments() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Insert mock documents
        let documents = try await testSubject.insert(documents: [
            Document.mock(projectID: try #require(project.id)),
            Document.mock(projectID: try #require(project.id))
        ])

        // Delete the documents
        let deleteCount = try await testSubject.delete(documents: documents)
        #expect(deleteCount == documents.count)

        // Verify the documents are deleted
        let remainingDocuments = try await testSubject.getDocuments(for: project)
        #expect(remainingDocuments.isEmpty)
    }

    // MARK: LLM Model

    @Test("Fetch Model Count Publisher")
    func fetchModelCountPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // Insert mock models
        _ = try await testSubject.insert(model: LLMModel.mock())
        _ = try await testSubject.insert(model: LLMModel.mock())

        await withCheckedContinuation { continuation in
            // Fetch the model count
            testSubject.getModelCount()
                .sink { modelCount in
                    #expect(modelCount == 2)
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Models Publisher")
    func fetchAllModelsPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        // Insert mock models
        let model1 = try await testSubject.insert(
            model: LLMModel.mock(name: "Model 1")
        )
        let model2 = try await testSubject.insert(
            model: LLMModel.mock(name: "Model 2")
        )

        // Fetch all models using the publisher
        await withCheckedContinuation { continuation in
            // Fetch the model count
            testSubject.getModels()
                .replaceError(with: [])
                .sink { fetchedModels in
                    // Verify fetched models
                    #expect(fetchedModels.count == 2)

                    let fetchedModel1 = fetchedModels[0]
                    let fetchedModel2 = fetchedModels[1]

                    #expect(fetchedModel1.id == 1)
                    #expect(fetchedModel1.name == "Model 1")
                    #expect(fetchedModel1.path == model1.path)
                    #expect(fetchedModel1.size == model1.size)
                    #expect(
                        Int(fetchedModel1.createdAt.timeIntervalSince1970) == Int(model1.createdAt.timeIntervalSince1970)
                    )
                    #expect(
                        Int(fetchedModel1.updatedAt.timeIntervalSince1970) == Int(model1.updatedAt.timeIntervalSince1970)
                    )

                    #expect(fetchedModel2.id == 2)
                    #expect(fetchedModel2.name == "Model 2")
                    #expect(fetchedModel2.path == model2.path)
                    #expect(fetchedModel2.size == model2.size)
                    #expect(
                        Int(fetchedModel2.createdAt.timeIntervalSince1970) == Int(model2.createdAt.timeIntervalSince1970)
                    )
                    #expect(
                        Int(fetchedModel2.updatedAt.timeIntervalSince1970) == Int(model2.updatedAt.timeIntervalSince1970)
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Models")
    func fetchAllModels() async throws {
        // Insert mock models
        let model1 = try await testSubject.insert(model: LLMModel.mock(name: "Model 1"))
        let model2 = try await testSubject.insert(model: LLMModel.mock(name: "Model 2"))

        // Fetch all models asynchronously
        let fetchedModels = try await testSubject.getModels()

        // Verify the fetched models
        #expect(fetchedModels.count == 2)

        let fetchedModel1 = fetchedModels[0]
        let fetchedModel2 = fetchedModels[1]

        #expect(fetchedModel1.id == 1)
        #expect(fetchedModel1.name == "Model 1")
        #expect(fetchedModel1.path == model1.path)
        #expect(fetchedModel1.size == model1.size)
        #expect(Int(fetchedModel1.createdAt.timeIntervalSince1970) == Int(model1.createdAt.timeIntervalSince1970))
        #expect(Int(fetchedModel1.updatedAt.timeIntervalSince1970) == Int(model1.updatedAt.timeIntervalSince1970))

        #expect(fetchedModel2.id == 2)
        #expect(fetchedModel2.name == "Model 2")
        #expect(fetchedModel2.path == model2.path)
        #expect(fetchedModel2.size == model2.size)
        #expect(Int(fetchedModel2.createdAt.timeIntervalSince1970) == Int(model2.createdAt.timeIntervalSince1970))
        #expect(Int(fetchedModel2.updatedAt.timeIntervalSince1970) == Int(model2.updatedAt.timeIntervalSince1970))
    }

    @Test("Insert Model")
    func insertModel() async throws {
        let model = LLMModel.mock()

        // Insert the model
        let insertedModel = try await testSubject.insert(model: model)
        let newID = try #require(insertedModel.id)
        #expect(newID == 1)

        // Verify inserted model properties
        #expect(insertedModel.name == model.name)
        #expect(insertedModel.path == model.path)
        #expect(insertedModel.size == model.size)
        #expect(Int(insertedModel.createdAt.timeIntervalSince1970) == Int(model.createdAt.timeIntervalSince1970))
        #expect(Int(insertedModel.updatedAt.timeIntervalSince1970) == Int(model.updatedAt.timeIntervalSince1970))
    }

    @Test("Fetch Model by ID")
    func fetchModelByID() async throws {
        let model = LLMModel.mock()

        // Insert the model
        let insertedModel = try await testSubject.insert(model: model)
        let newID = try #require(insertedModel.id)

        // Fetch the model by ID
        let fetchedModel = try await testSubject.getModel(id: newID)

        // Verify fetched model properties
        #expect(fetchedModel.id == insertedModel.id)
        #expect(fetchedModel.name == insertedModel.name)
        #expect(fetchedModel.path == insertedModel.path)
        #expect(fetchedModel.size == insertedModel.size)
        #expect(Int(fetchedModel.createdAt.timeIntervalSince1970) == Int(insertedModel.createdAt.timeIntervalSince1970))
        #expect(Int(fetchedModel.updatedAt.timeIntervalSince1970) == Int(insertedModel.updatedAt.timeIntervalSince1970))
    }

    @Test("Update Model")
    func updateModel() async throws {
        let model = try await testSubject.insert(model: LLMModel.mock())

        // Update the model
        let updatedModel = LLMModel(
            id: try #require(model.id),
            name: "Updated Model",
            path: "/new/path/to/model",
            size: 2048,
            createdAt: model.createdAt,
            updatedAt: Date()
        )

        let result = try await testSubject.update(model: updatedModel)

        // Verify updated model properties
        #expect(result.id == updatedModel.id)
        #expect(result.name == updatedModel.name)
        #expect(result.path == updatedModel.path)
        #expect(result.size == updatedModel.size)
        #expect(Int(result.createdAt.timeIntervalSince1970) == Int(model.createdAt.timeIntervalSince1970))
        #expect(Int(result.updatedAt.timeIntervalSince1970) == Int(updatedModel.updatedAt.timeIntervalSince1970))
    }

    @Test("Delete Model")
    func deleteModel() async throws {
        let model = try await testSubject.insert(model: LLMModel.mock())

        // Delete the model
        let deleteSuccess = try await testSubject.delete(
            model: model,
            deleteModelOnDisk: false
        )
        #expect(deleteSuccess == true)

        // Verify deletion
        do {
            _ = try await testSubject.getModel(id: try #require(model.id))
            Issue.record("Expected valueNotFound error")
        } catch let error as DocuBotService.PersistenceError {
            #expect(error == .valueNotFound)
        }
    }

} // swiftlint:disable:this file_length
