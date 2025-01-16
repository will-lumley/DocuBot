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

    @Test("Insert Project")
    func insertProject() async throws {
        let project = Project.mock()

        // Insert the project
        let insertedProject = try await testSubject.insert(project: project)
        let newID = try #require(insertedProject.id)

        // Fetch the project
        let fetchedProject = try await testSubject.getProject(id: newID)

        // Ensure our initial project and inserted project are identical
        #expect(insertedProject.path == project.path)
        #expect(insertedProject.name == project.name)
        #expect(insertedProject.urlBookmarkData == project.urlBookmarkData)
        #expect(insertedProject.documentationChecksum == project.documentationChecksum)
        #expect(insertedProject.exampleQuestions == project.exampleQuestions)
        #expect(insertedProject.alertStatus == project.alertStatus)
        #expect(insertedProject.needsFullResync == project.needsFullResync)
        #expect(Int(insertedProject.createdAt.timeIntervalSince1970) == Int(project.createdAt.timeIntervalSince1970))
        #expect(Int(insertedProject.updatedAt.timeIntervalSince1970) == Int(project.updatedAt.timeIntervalSince1970))

        // Ensure our fetched project and inserted project are identical
        #expect(insertedProject.id == fetchedProject.id)
        #expect(insertedProject.path == fetchedProject.path)
        #expect(insertedProject.name == fetchedProject.name)
        #expect(insertedProject.urlBookmarkData == fetchedProject.urlBookmarkData)
        #expect(insertedProject.documentationChecksum == fetchedProject.documentationChecksum)
        #expect(insertedProject.exampleQuestions == fetchedProject.exampleQuestions)
        #expect(insertedProject.alertStatus == fetchedProject.alertStatus)
        #expect(insertedProject.needsFullResync == fetchedProject.needsFullResync)
        #expect(
            Int(insertedProject.createdAt.timeIntervalSince1970) == Int(fetchedProject.createdAt.timeIntervalSince1970)
        )
        #expect(
            Int(insertedProject.updatedAt.timeIntervalSince1970) == Int(fetchedProject.updatedAt.timeIntervalSince1970)
        )
    }

    @Test("Fetch Single Project")
    func fetchSingleProject() async throws {
        let project = Project.mock()

        // Insert the project
        let insertedProject = try await testSubject.insert(project: project)
        let newID = try #require(insertedProject.id)

        // Fetch the project
        let fetchedProject = try await testSubject.getProject(id: newID)

        // Ensure our fetched project and inserted project are identical
        #expect(fetchedProject.id == 1)
        #expect(project.path == fetchedProject.path)
        #expect(project.name == fetchedProject.name)
        #expect(project.urlBookmarkData == fetchedProject.urlBookmarkData)
        #expect(project.documentationChecksum == fetchedProject.documentationChecksum)
        #expect(project.exampleQuestions == fetchedProject.exampleQuestions)
        #expect(project.alertStatus == fetchedProject.alertStatus)
        #expect(project.needsFullResync == fetchedProject.needsFullResync)
        #expect(Int(project.createdAt.timeIntervalSince1970) == Int(fetchedProject.createdAt.timeIntervalSince1970))
        #expect(Int(project.updatedAt.timeIntervalSince1970) == Int(fetchedProject.updatedAt.timeIntervalSince1970))
    }

    @Test("Fetch Single Project Publisher")
    func fetchSingleProjectPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        let project = Project.mock()

        // Insert the project
        let insertedProject = try await testSubject.insert(project: project)
        let newID = try #require(insertedProject.id)

        await withCheckedContinuation { continuation in
            // Fetch the project
            testSubject.getProject(id: newID)
                .sink { fetchedProject in
                    // Ensure our fetched project and inserted project are identical
                    #expect(fetchedProject.id == 1)
                    #expect(project.path == fetchedProject.path)
                    #expect(project.name == fetchedProject.name)
                    #expect(project.urlBookmarkData == fetchedProject.urlBookmarkData)
                    #expect(project.documentationChecksum == fetchedProject.documentationChecksum)
                    #expect(project.exampleQuestions == fetchedProject.exampleQuestions)
                    #expect(project.alertStatus == fetchedProject.alertStatus)
                    #expect(project.needsFullResync == fetchedProject.needsFullResync)
                    #expect(
                        Int(project.createdAt.timeIntervalSince1970) == Int(fetchedProject.createdAt.timeIntervalSince1970)
                    )
                    #expect(
                        Int(project.updatedAt.timeIntervalSince1970) == Int(fetchedProject.updatedAt.timeIntervalSince1970)
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Fetch All Projects Publisher")
    func fetchAllProjectPublisher() async throws {
        var cancellables: Set<AnyCancellable> = []

        let project1 = Project.mock(name: "Project1")
        let project2 = Project.mock(name: "Project2")

        // Insert the projects
        _ = try await testSubject.insert(project: project1)
        _ = try await testSubject.insert(project: project2)

        await withCheckedContinuation { continuation in
            // Fetch the project
            testSubject.getProjects()
                .replaceError(with: []) // The test will crash if there's an error
                .sink { fetchedProjects in
                    let fetchedProject1 = fetchedProjects[0]
                    let fetchedProject2 = fetchedProjects[1]

                    // Ensure our fetched project and inserted project are identical
                    #expect(fetchedProject1.id == 1)
                    #expect(project1.path == fetchedProject1.path)
                    #expect(fetchedProject1.name == "Project1")
                    #expect(project1.name == fetchedProject1.name)
                    #expect(project1.urlBookmarkData == fetchedProject1.urlBookmarkData)
                    #expect(project1.documentationChecksum == fetchedProject1.documentationChecksum)
                    #expect(project1.exampleQuestions == fetchedProject1.exampleQuestions)
                    #expect(project1.alertStatus == fetchedProject1.alertStatus)
                    #expect(project1.needsFullResync == fetchedProject1.needsFullResync)
                    #expect(Int(project1.createdAt.timeIntervalSince1970) == Int(fetchedProject1.createdAt.timeIntervalSince1970))
                    #expect(Int(project1.updatedAt.timeIntervalSince1970) == Int(fetchedProject1.updatedAt.timeIntervalSince1970))

                    #expect(fetchedProject2.id == 2)
                    #expect(project2.path == fetchedProject2.path)
                    #expect(fetchedProject2.name == "Project2")
                    #expect(project2.name == fetchedProject2.name)
                    #expect(project2.urlBookmarkData == fetchedProject2.urlBookmarkData)
                    #expect(project2.documentationChecksum == fetchedProject2.documentationChecksum)
                    #expect(project2.exampleQuestions == fetchedProject2.exampleQuestions)
                    #expect(project2.alertStatus == fetchedProject2.alertStatus)
                    #expect(project2.needsFullResync == fetchedProject2.needsFullResync)
                    #expect(Int(project2.createdAt.timeIntervalSince1970) == Int(fetchedProject2.createdAt.timeIntervalSince1970))
                    #expect(Int(project2.updatedAt.timeIntervalSince1970) == Int(fetchedProject2.updatedAt.timeIntervalSince1970))

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Delete Project")
    func deleteProject() async throws {
        let project = Project(
            id: nil,
            path: "/path/to/project",
            name: "Sample Project",
            urlBookmarkData: Data(),
            documentationCheckSum: "abc123",
            exampleQuestions: ["What is this?", "How does it work?"],
            alertStatus: .none,
            needsFullResync: false,
            createdAt: Date(),
            updatedAt: Date()
        )

        // Insert the project
        let insertedProject = try await testSubject.insert(project: project)
        let newID = try #require(insertedProject.id)

        // Delete the project
        let deleteSuccess = try await testSubject.delete(project: insertedProject)
        #expect(deleteSuccess == true)

        // Verify deletion
        do {
            _ = try await testSubject.getProject(id: newID)
            Issue.record("Expected valueNotFound error")
        } catch let error as DocuBotService.PersistenceError {
            #expect(error == .valueNotFound)
        }
    }

    @Test("Update Project")
    func updateProject() async throws {
        var project = Project(
            id: nil,
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

        // Insert the project
        project = try await testSubject.insert(project: project)

        // Update the project
        let updatedProject = Project(
            id: project.id,
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
        _ = try await testSubject.update(project: updatedProject)

        // Verify update
        let fetchedProject = try await testSubject.getProject(id: try #require(project.id))
        #expect(fetchedProject.id == 1)
        #expect(fetchedProject.path == "/path/to/project")
        #expect(fetchedProject.name == "Updated Project")
        #expect(fetchedProject.urlBookmarkData == Data())
        #expect(fetchedProject.documentationChecksum == "xyz789")
        #expect(fetchedProject.exampleQuestions == ["Why is this?", "Who does it work?"])
        #expect(fetchedProject.alertStatus == .warning(warning: .isDirty))
        #expect(fetchedProject.needsFullResync == true)
    }

    // MARK: ProjectSettings

    @Test("Insert Project Settings")
    func insertProjectSettings() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Create a mock model and insert it
        let model = try await testSubject.insert(model: LLMModel.mock())

        // Create a mock project settings object
        let settings = ProjectSettings.mock(
            projectID: try #require(project.id),
            modelID: try #require(model.id)
        )

        // Insert the settings
        let insertedSettings = try await testSubject.insert(settings: settings)
        _ = try #require(insertedSettings.id)

        // Ensure the inserted settings and initial settings match
        #expect(insertedSettings.projectID == settings.projectID)
        #expect(insertedSettings.modelID == settings.modelID)
        #expect(insertedSettings.supportedFormats == settings.supportedFormats)
        #expect(insertedSettings.language == settings.language)
        #expect(insertedSettings.embeddingModel == settings.embeddingModel)
        #expect(insertedSettings.similarityMetric == settings.similarityMetric)
        #expect(insertedSettings.seed == settings.seed)
        #expect(insertedSettings.topK == settings.topK)
        #expect(insertedSettings.topP == settings.topP)
        #expect(insertedSettings.contextLength == settings.contextLength)
        #expect(insertedSettings.temperature == settings.temperature)
        #expect(insertedSettings.batchSize == settings.batchSize)
        #expect(insertedSettings.stopSequence == settings.stopSequence)
        #expect(insertedSettings.maxTokenCount == settings.maxTokenCount)
        #expect(insertedSettings.systemPrompt == settings.systemPrompt)
        #expect(insertedSettings.strictMode == settings.strictMode)
        #expect(Int(insertedSettings.createdAt.timeIntervalSince1970) == Int(settings.createdAt.timeIntervalSince1970))
        #expect(Int(insertedSettings.updatedAt.timeIntervalSince1970) == Int(settings.updatedAt.timeIntervalSince1970))
    }

    @Test("Fetch Project Settings")
    func fetchProjectSettings() async throws {
        // Create a mock project and insert it
        let project = try await testSubject.insert(project: Project.mock())

        // Create a mock model and insert it
        let model = try await testSubject.insert(model: LLMModel.mock())

        // Create a mock project settings object
        let settings = ProjectSettings.mock(
            projectID: try #require(project.id),
            modelID: try #require(model.id)
        )

        // Insert the settings
        let insertedSettings = try await testSubject.insert(settings: settings)
        _ = try #require(insertedSettings.id)


        // Fetch the settings for the project
        let fetchedSettings = try await testSubject.getProjectSettings(for: project)

        // Ensure the fetched settings match the inserted settings
        #expect(fetchedSettings.id == insertedSettings.id)
        #expect(fetchedSettings.projectID == settings.projectID)
        #expect(fetchedSettings.modelID == settings.modelID)
        #expect(fetchedSettings.supportedFormats == settings.supportedFormats)
        #expect(fetchedSettings.language == settings.language)
        #expect(fetchedSettings.embeddingModel == settings.embeddingModel)
        #expect(fetchedSettings.similarityMetric == settings.similarityMetric)
        #expect(fetchedSettings.seed == settings.seed)
        #expect(fetchedSettings.topK == settings.topK)
        #expect(fetchedSettings.topP == settings.topP)
        #expect(fetchedSettings.contextLength == settings.contextLength)
        #expect(fetchedSettings.temperature == settings.temperature)
        #expect(fetchedSettings.batchSize == settings.batchSize)
        #expect(fetchedSettings.stopSequence == settings.stopSequence)
        #expect(fetchedSettings.maxTokenCount == settings.maxTokenCount)
        #expect(fetchedSettings.systemPrompt == settings.systemPrompt)
        #expect(fetchedSettings.strictMode == settings.strictMode)
        #expect(Int(fetchedSettings.createdAt.timeIntervalSince1970) == Int(settings.createdAt.timeIntervalSince1970))
        #expect(Int(fetchedSettings.updatedAt.timeIntervalSince1970) == Int(settings.updatedAt.timeIntervalSince1970))
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

}

// MARK: - Project

private extension Project {

    static func mock(
        id: Int64? = nil,
        name: String = "Sample Project"
    ) -> Project {
        .init(
            id: id,
            path: "/path/to/project",
            name: name,
            urlBookmarkData: Data(),
            documentationCheckSum: "abc123",
            exampleQuestions: ["What is this?", "How does it work?"],
            alertStatus: .warning(warning: .directoryChanged),
            needsFullResync: false,
            createdAt: Date(),
            updatedAt: Date()
        )
    }

}

// MARK: - ProjectSettings

private extension ProjectSettings {

    static func mock(
        id: Int64? = nil,
        projectID: Int64 = 1,
        modelID: Int64 = 1
    ) -> ProjectSettings {
        .init(
            id: id,
            projectID: projectID,
            modelID: 1,
            supportedFormats: [.txt, .rtf],
            language: .english,
            embeddingModel: .distilbert,
            similarityMetric: .cosine,
            seed: 12345,
            topK: 10,
            topP: 0.8,
            contextLength: 512,
            temperature: 0.7,
            batchSize: 16,
            stopSequence: nil,
            maxTokenCount: 1024,
            systemPrompt: "Summarize the document.",
            strictMode: true,
            createdAt: Date(),
            updatedAt: Date()
        )
    }

}

// MARK: - LLMModel

private extension LLMModel {

    static func mock(
        id: Int64? = nil,
        name: String = "Cool Model Name"
    ) -> LLMModel {
        .init(
            id: id,
            name: name,
            path: "/path/to/model",
            size: 4000,
            createdAt: .now,
            updatedAt: .now
        )
    }

}

// MARK: - Document

private extension Document {

    static func mock(
        id: Int64? = nil,
        projectID: Int64 = 1
    ) -> Document {
        .init(
            id: id,
            url: URL(string: "https://example.com/document\(id ?? 0)")!,
            fileFormat: .rtf,
            content: "Sample content \(id ?? 0)",
            checksum: "checksum\(id ?? 0)",
            projectID: projectID,
            embeddings: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    }

} // swiftlint:disable:this file_length
