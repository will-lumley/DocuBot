//
//  ConfigureProjectViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import Combine
import DocuBotModel
@testable import DocuBotViewModel
import Foundation
import Testing

// swiftlint:disable line_length

@Suite(
    "ConfigureProjectViewModelTests",
    .serialized,
    .tags(.view),
    .timeLimit(.minutes(1))
)
class ConfigureProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable { // swiftlint:disable:this type_body_length

    // MARK: - Properties

    /// Storage for our subscriptions
    var cancellables = Set<AnyCancellable>()

    // MARK: - Mock

    func mockForCreating() async -> ConfigureProjectViewModel {
        // Load a testing model into our DB
        let model = await self.persistTestModel()

        let testSubject = ConfigureProjectViewModel(
            availableModels: [model],
            serviceContainer: self.serviceContainer
        )
        testSubject.configureBindingsIfNeeded()

        return testSubject
    }

    func mockForEditing(
        with alertStatus: Project.AlertStatus = .none
    ) async throws -> ConfigureProjectViewModel {
        // Load a testing model into our DB
        let insertedModel = await self.persistTestModel()

        let projectID = Int64(1)
        let project = Project.mock(
            id: projectID,
            alertStatus: alertStatus
        )
        let settings = ProjectSettings.mock(
            projectID: projectID,
            modelID: try insertedModel.id.orThrow(LLMModel.ModelError.missingID)
        )

        // Insert our Project & Settings into the DB
        let insertedProject = try await persistenceService.insert(
            project: project
        )
        let insertedSettings = try await persistenceService.insert(settings: settings)

        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(
                project: insertedProject,
                settings: insertedSettings,
                model: insertedModel
            ),
            availableModels: [insertedModel],
            serviceContainer: self.serviceContainer
        )
        testSubject.configureBindingsIfNeeded()

        return testSubject
    }

    // MARK: - Tests

    @Test("Label Values")
    func labelValues() async {

        // GIVEN we have a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // THEN our labels, titles, etc have the correct values
        #expect(testSubject.generalSectionTitle == "General")
        #expect(testSubject.generalSectionSubtitle == "Tell us a bit about your project.")
        #expect(testSubject.projectNameTitle == "Project Name")
        #expect(testSubject.projectDirectoryTitle == "Project Directory")
        #expect(testSubject.languageTitle == "Language")
        #expect(testSubject.modelTitle == "LLM Model")
        #expect(testSubject.formatSectionTitle == "What format is your documentation in?")
        #expect(testSubject.similaritySectionTitle == "Similarity Metric Configuration")
        #expect(testSubject.embeddingModelTitle == "Embedding Model")
        #expect(testSubject.similarityMetricTitle == "Similarity Metric")
        #expect(testSubject.llmSectionTitle == "LLM Configuration")
        #expect(
            testSubject.formatSectionSubtitle == "We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later."
        )
        #expect(
            testSubject.similaritySectionSubtitle == "These options determine how the similarity between query inputs and documentation is calculated, affecting the accuracy of results. Adjust them only if you need something specific.\nChanging these will require a full resync of your project."
        )
        #expect(
            testSubject.llmSectionSubitle == "Adjust advanced settings for the LLM, including model parameters and behavior to optimise performance and responsiveness. Adjust them only if you need something specific."
        )

        #expect(testSubject.systemPromptTitle == "System Prompt")
        #expect(testSubject.seedTitle == "Seed")
        #expect(testSubject.topKTitle == "Top K")
        #expect(testSubject.topPTitle == "Top P")
        #expect(testSubject.temperatureTitle == "Temperature")
        #expect(testSubject.stopSequenceTitle == "Stop Sequence")
        #expect(testSubject.maxTokenCountTitle == "Maximum Token Count")
        #expect(testSubject.strictModeTitle == "Strict Mode")
        #expect(testSubject.resetDefaultButtonTitle == "Reset Default Values")
    }

    @Test("Initialisation - Creating")
    func initialisationCreating() async {
        // GIVEN a new ConfigureProjectViewModel for creating a project
        let testSubject = await self.mockForCreating()

        // THEN properties are set to default values
        #expect(testSubject.projectInfo == nil)
        #expect(testSubject.projectDirectory == nil)
        #expect(testSubject.projectName == "")
        #expect(testSubject.selectedLanguage == .english)
        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)
    }

    @Test("Initialisation - Editing")
    func initialisationEditing() async throws {
        // GIVEN we have a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // THEN properties are set based on the ProjectInfo
        #expect(testSubject.projectInfo != nil)
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: "/Users/will/Desktop/Project_1"))
        #expect(testSubject.projectName == "Project 1")
        #expect(testSubject.selectedLanguage == .english)
        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)
    }

    @Test("Project Directory Text")
    func projectDirectoryText() async {
        // GIVEN we have our ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // THEN our ProjectDirectoryText is empty
        #expect(testSubject.projectDirectoryText == "Select a Directory")

        // WHEN we set the ProjectDirectory URL
        testSubject.projectDirectory = URL(string: "/example/path-to-project")

        // THEN our ProjectDirectoryText is correctly set
        #expect(testSubject.projectDirectoryText == "/example/path-to-project")
    }

    @Test("Form Title - Creating")
    func formTitleCreating() async {
        // GIVEN we have our ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // THEN the form title is correctly set
        #expect(testSubject.formTitle == L10n.ConfigureProject.Creating.formTitle)
    }

    @Test("Form Title - Editing")
    func formTitleEditing() async throws {
        // GIVEN we have our ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // THEN the form title is correctly set
        #expect(testSubject.formTitle == L10n.ConfigureProject.Editing.formTitle)
    }

    @Test("Save Button Title - Creating")
    func saveButtonTitleCreating() async {
        // GIVEN we have our ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // THEN the form title is correctly set
        #expect(testSubject.saveButtonTitle == L10n.ConfigureProject.Creating.createButton)
    }

    @Test("Save Button Title - Editing")
    func saveButtonTitleEditing() async throws {
        // GIVEN we have our ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // THEN the form title is correctly set
        #expect(testSubject.saveButtonTitle == L10n.ConfigureProject.Editing.createButton)
    }

    @Test("Form Validation - Creating - Missing Directory")
    func formValidationCreatingMissingDirectory() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a project directory has been selected."
            )
        )
    }

    @Test("Form Validation - Creating - Missing Directory Data")
    func formValidationCreatingMissingDirectoryData() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not the secure URL data
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "No secure directory data is avaiable to DocuBot."
            )
        )
    }

    @Test("Form Validation - Creating - Missing Name")
    func formValidationCreatingMissingName() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not the project name
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a project name has been provided."
            )
        )
    }

    @Test("Form Validation - Creating - Missing Format")
    func formValidationCreatingMissingFormat() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not our format types
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: false)]

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that at least one format has been enabled."
            )
        )
    }

    @Test("Form Validation - Creating - Missing Seed")
    func formValidationCreatingMissingSeed() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not our seed
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a valid seed value is provided."
            )
        )
    }

    @Test("Form Validation - Creating - Missing TopK")
    func formValidationCreatingMissingTopK() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not our TopK
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a valid Top-K value is provided."
            )
        )
    }

    @Test("Form Validation - Creating - Invalid TopP - Lower Bounds")
    func formValidationCreatingInvalidTopPLower() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = -1

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
            )
        )
    }

    @Test("Form Validation - Creating - Invalid TopP - Upper Bounds")
    func formValidationCreatingInvalidTopPUpper() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = 11

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
            )
        )
    }

    @Test("Form Validation - Creating - Missing Token Count")
    func formValidationCreatingMissingTokenCount() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a valid maximum token count is provided."
            )
        )
    }

    @Test("Form Validation - Creating - Missing System Prompt")
    func formValidationCreatingMissingSystemPrompt() async throws {
        // GIVEN a ConfigureProjectViewModel for creating a new Project & Settings
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = ""

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Create Project",
                message: "Please ensure that a valid system prompt is provided."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Directory")
    func formValidationEditingMissingDirectory() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not the project directory
        testSubject.projectDirectory = nil

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a project directory has been selected."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Directory Data")
    func formValidationEditingMissingDirectoryData() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not the secure URL data
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = nil

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "No secure directory data is avaiable to DocuBot."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Name")
    func formValidationEditingMissingName() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not the project name
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = ""

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a project name has been provided."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Format")
    func formValidationEditingMissingFormat() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not our format types
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: false)]

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that at least one format has been enabled."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Seed")
    func formValidationEditingMissingSeed() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not our seed
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a valid seed value is provided."
            )
        )
    }

    @Test("Form Validation - Editing - Missing TopK")
    func formValidationEditingMissingTopK() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not our TopK
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a valid Top-K value is provided."
            )
        )
    }

    @Test("Form Validation - Editing - Invalid TopP - Lower Bounds")
    func formValidationEditingInvalidTopPLower() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = -1

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
            )
        )
    }

    @Test("Form Validation - Editing - Invalid TopP - Upper Bounds")
    func formValidationEditingInvalidTopPUpper() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = 11

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
            )
        )
    }

    @Test("Form Validation - Editing - Missing Token Count")
    func formValidationEditingMissingTokenCount() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 0

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a valid maximum token count is provided."
            )
        )
    }

    @Test("Form Validation - Editing - Missing System Prompt")
    func formValidationEditingMissingSystemPrompt() async throws {
        // GIVEN a ConfigureProjectViewModel for modifying an existing Project & Settings
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we ensure we have filled out some of the details, but not our system prompt
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = ""

        // WHEN try and save
        await testSubject.saveButtonSelected()

        // THEN an alert is presented
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct title and message
        #expect(
            alert == .init(
                title: "Failed to Update Project",
                message: "Please ensure that a valid system prompt is provided."
            )
        )
    }

    @Test("Save Project - Creating")
    func createProject() async throws {
        // Ensure that there is no Projects in the DB before we start
        let allProjects = try await persistenceService.getProjects()
        #expect(allProjects.count == 0)

        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we ensure we have filled out all of the details
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.stopSequence = "abc"
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"
        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance
        testSubject.strictMode = true

        // WHEN we save the Project
        await testSubject.saveButtonSelected()

        // THEN a new Project has been created on the DB
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one new created Project
        #expect(savedProjects.count == 1)
        let savedProject = try #require(savedProjects.first)

        // THEN the Project has the correct attributes
        #expect(savedProject.id == 1)
        #expect(savedProject.path == "/example/path")
        #expect(savedProject.name == "Test Name")
        #expect(savedProject.urlBookmarkData == Data())
        #expect(savedProject.documentationChecksum == nil)
        #expect(savedProject.exampleQuestions == [])
        #expect(savedProject.alertStatus == .error(error: .firstSync))
        #expect(
            savedProject.createdAt.secondsFrom1970 == Date.now.secondsFrom1970
        )
        #expect(
            savedProject.updatedAt.secondsFrom1970 == Date.now.secondsFrom1970
        )

        // THEN a new ProjectSettings has been created on the DB
        let settings = try await persistenceService.getProjectSettings(
            for: .mock(id: 1)
        )

        // THEN the ProjectSettings has the correct attributes
        #expect(settings.id == 1)
        #expect(settings.projectID == 1)
        #expect(settings.modelID == 1)
        #expect(settings.supportedFormats == [.rtf, .txt])
        #expect(settings.language == .english)
        #expect(settings.embeddingModel == .multiQaMiniLm)
        #expect(settings.similarityMetric == .euclideanDistance)
        #expect(settings.seed == 10)
        #expect(settings.topK == 5)
        #expect(settings.topP == 0.5)
        #expect(settings.stopSequence == "abc")
        #expect(settings.maxTokenCount == 1024)
        #expect(settings.systemPrompt == "This is a system prompt")
        #expect(settings.strictMode == true)

        // THEN we've opened up our Project's new window
        let newWindow = try #require(testSubject.onOpen.value)
        #expect(
            newWindow == .project(
                .init(project: savedProject)
            )
        )
    }

    @Test("Save Project - Editing")
    func editProject() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // THEN there is only 1 project
        #expect(try await persistenceService.getProjects().count == 1)

        // WHEN we ensure we have filled out all of the details
        testSubject.selectedModel = .mock(id: 1)
        testSubject.projectName = "Test Name 2"
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"
        testSubject.strictMode = true
        testSubject.stopSequence = "xyz"

        // We won't change the properties below as it will trigger a
        // resync warning - so we'll test the changing of these properties
        // in a the "resync" warning tests.
        /*
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance
         */

        // WHEN we save the Project
        await testSubject.saveButtonSelected()

        // THEN a new Project has been created on the DB
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one new created Project
        #expect(savedProjects.count == 1)
        let savedProject = try #require(savedProjects.first)

        // THEN the Project has the correct attributes
        #expect(savedProject.id == 1)
        #expect(savedProject.name == "Test Name 2")
        #expect(savedProject.urlBookmarkData == Data())
        #expect(
            savedProject.createdAt.secondsFrom1970 == Date.now.secondsFrom1970
        )
        #expect(
            savedProject.updatedAt.secondsFrom1970 == Date.now.secondsFrom1970
        )

        // THEN a new ProjectSettings has been created on the DB
        let settings = try await persistenceService.getProjectSettings(
            for: .mock(id: 1)
        )

        // THEN the ProjectSettings has the correct attributes
        #expect(settings.id == 1)
        #expect(settings.projectID == 1)
        #expect(settings.modelID == 1)
        #expect(settings.language == .english)
        #expect(settings.seed == 20)
        #expect(settings.topK == 5)
        #expect(settings.topP == 0.5)
        #expect(settings.stopSequence == "xyz")
        #expect(settings.maxTokenCount == 1024)
        #expect(settings.systemPrompt == "This is a system prompt")
        #expect(settings.strictMode == true)

        // THEN there is no new window that's presented
        #expect(testSubject.onOpen.value == nil)
    }

    @Test("Reset LLM Options")
    func resetLlmOptions() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.selectedModel = .mock(id: 1)
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.temperature = 15
        testSubject.stopSequence = "foobar"
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"

        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance

        // WHEN the resetLlmOptions method is called
        testSubject.resetLlmOptions()

        // THEN the LLM options are reset to their default values
        #expect(testSubject.seed == 1234)
        #expect(testSubject.topK == 40)
        #expect(testSubject.topP == 0.9)
        #expect(testSubject.temperature == 0.2)
        #expect(testSubject.stopSequence == "")
        #expect(testSubject.maxTokenCount == 1048576)
        #expect(testSubject.systemPrompt == "You are a helpful assistant named DocuBot. DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries. You have been trained on a directory that contains the relevant documentation. You are expected to answer the user's questions to their code base. If you don't know the answer, simply say that. Avoid long paragraphs and break them up with newlines if need be. All responses you generate should be formatted in Markdown. Use `#` for headers, `*` or `-` for bullet points, and backticks (`) for inline code and code blocks. Include links using [text](URL) format.")
        #expect(testSubject.strictMode == false)

        // THEN nothing else has been changed
        #expect(testSubject.projectName == "Test Name")
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: "/example/path"))
        #expect(testSubject.embeddingModel == .multiQaMiniLm)
        #expect(testSubject.similarityMetric == .euclideanDistance)
        #expect(testSubject.selectedLanguage == .english)
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 1, format: .rtf, isEnabled: true),
                .init(order: 2, format: .md, isEnabled: false),
                .init(order: 2, format: .txt, isEnabled: true)
            ]
        )
    }

    @Test("Reset Similarity Options")
    func resetSimilarityOptions() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.selectedModel = .mock(id: 1)
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.temperature = 15
        testSubject.stopSequence = "foobar"
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"

        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance

        // WHEN the resetSimilarityOptions button is selected
        testSubject.resetSimilarityOptions()

        // THEN the similarity options are reset to their default values
        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)

        // THEN nothing else has been changed
        #expect(testSubject.projectName == "Test Name")
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: "/example/path"))
        #expect(testSubject.seed == 20)
        #expect(testSubject.topK == 5)
        #expect(testSubject.topP == 0.5)
        #expect(testSubject.temperature == 15)
        #expect(testSubject.stopSequence == "foobar")
        #expect(testSubject.maxTokenCount == 1024)
        #expect(testSubject.systemPrompt == "This is a system prompt")
        #expect(testSubject.strictMode == false)
    }

    @Test("ReSync Message - None - Creating")
    func noResyncMessageCreating() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we have our details filled out
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Metric Changed - Creating")
    func resyncMessageMetricChangedCreating() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we change the metric
        testSubject.similarityMetric = .dotProduct
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - EmbeddedModel Changed - Creating")
    func resyncMessageEmbeddedModelChangedCreating() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we change the embedding model
        testSubject.embeddingModel = .miniLmAll
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Directory Changed - Creating")
    func resyncMessageDirectoryChangedCreating() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we change the directory
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Formats Changed - Creating")
    func resyncMessageFormatsChangedCreating() async {
        // GIVEN a ConfigureProjectViewModel for creating
        let testSubject = await self.mockForCreating()

        // WHEN we change the formats
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true)
        ]
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - None - Editing")
    func noResyncMessageEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Metric Changed - Editing")
    func resyncMessageMetricChangedEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our metric isn't dotProduct
        #expect(testSubject.similarityMetric != .dotProduct)

        // WHEN we change the metric to dotProduct
        testSubject.similarityMetric = .dotProduct

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try await testSubject.$alertConfiguration
            .firstCompactValue()

        #expect(
            alert == .init(
                title: "Re-Sync Will Be Needed",
                message: "Changing the similarity metric will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.",
                primaryAction: .init(title: "Save Settings") { }
            )
        )

        // WHEN the alert's action is called
        await alert?.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService
            .getProjects()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)
        let savedSettings = try await persistenceService
            .getProjectSettings(for: savedProject)

        // THEN the Metric has been updated correctly
        #expect(savedSettings.similarityMetric == .dotProduct)
    }

    @Test("ReSync Message - EmbeddedModel Changed - Editing")
    func resyncMessageEmbeddedModelChangedEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our metric isn't dotProduct
        #expect(testSubject.embeddingModel != .miniLmAll)

        // WHEN we change the model to dotProduct
        testSubject.embeddingModel = .miniLmAll

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try await testSubject.$alertConfiguration
            .firstCompactValue()
        #expect(
            alert == .init(
                title: "Re-Sync Will Be Needed",
                message: "Changing the embedding model will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.",
                primaryAction: .init(title: "Save Settings") { }
            )
        )

        // WHEN the alert's action is called
        await alert?.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)
        let savedSettings = try await persistenceService.getProjectSettings(for: savedProject)

        // THEN the Metric has been updated correctly
        #expect(savedSettings.embeddingModel == .miniLmAll)
    }

    @Test("ReSync Message - Directory Changed - Editing")
    func resyncMessageDirectoryChangedEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our directory isn't /example/path
        #expect(testSubject.projectDirectory != URL(fileURLWithPath: "/example/path"))

        // WHEN we change the directory
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data(
            repeating: 1, count: 10
        )

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()
        #expect(
            alert == .init(
                title: "Re-Sync Will Be Needed",
                message: "Changing the directory will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.",
                primaryAction: .init(title: "Save Settings") { }
            )
        )

        // WHEN the alert's action is called
        await alert?.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)

        #expect(savedProject.path == "/example/path")
        #expect(
            savedProject.urlBookmarkData == Data(repeating: 1, count: 10)
        )
    }

    @Test("ReSync Message - Formats Changed - Editing")
    func resyncMessageFormatsChangedEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we change the formats
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .txt, isEnabled: true),
            .init(order: 3, format: .md, isEnabled: false),
            .init(order: 5, format: .other("foo"), isEnabled: false),
            .init(order: 6, format: .other("bar"), isEnabled: true)
        ]

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try await testSubject.$alertConfiguration
            .firstCompactValue()
        #expect(
            alert == .init(
                title: "Re-Sync Will Be Needed",
                message: "Changing the formats of the documentation that DocuBot has access to will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.",
                primaryAction: .init(title: "Save Settings") { }
            )
        )

        // WHEN the alert's action is called
        await alert?.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)
        let savedSettings = try await persistenceService
            .getProjectSettings(for: savedProject)

        // THEN the Formats have been updated correctly
        #expect(
            savedSettings.supportedFormats == [
                .rtf,
                .txt,
                .other("bar")
            ]
        )
    }

    @Test("New Alert Status - None - Editing")
    func newAlertStatusNoneEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we change nothing
        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN the Project & Settings is saved
        let savedProject = try await persistenceService.getProject(
            id: try #require(testSubject.projectInfo?.project.id)
        )

        // THEN there is no alert status on the model
        #expect(savedProject.alertStatus == .none)
    }

    @Test("New Alert Status - Metric Changed - Editing")
    func newAlertStatusMetricEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our metric isn't dotProduct
        #expect(testSubject.similarityMetric != .dotProduct)

        // WHEN we change the metric to dotProduct
        testSubject.similarityMetric = .dotProduct

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try #require(
            try await testSubject.$alertConfiguration.firstCompactValue()
        )

        // WHEN the alert's action is called
        await alert.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService
            .getProjects()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)

        // THEN the AlertStatus has been set appropriately
        #expect(
            savedProject.alertStatus == .warning(warning: .metricChanged)
        )
    }

    @Test("New Alert Status - Embedded Model Changed - Editing")
    func newAlertStatusModelEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our metric isn't miniLmAll
        #expect(testSubject.embeddingModel != .miniLmAll)

        // WHEN we change the model to miniLmAll
        testSubject.embeddingModel = .miniLmAll

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try #require(
            try await testSubject.$alertConfiguration.firstCompactValue()
        )

        // WHEN the alert's action is called
        await alert.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)

        // THEN the AlertStatus has been set appropriately
        #expect(
            savedProject.alertStatus == .warning(warning: .modelChanged)
        )
    }

    @Test("New Alert Status - Directory Changed - Editing")
    func newAlertStatusDirectoryEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // WHEN we change the directory
        testSubject.projectDirectory = URL(fileURLWithPath: "/foo/bar")

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try #require(
            try await testSubject.$alertConfiguration.firstCompactValue()
        )

        // WHEN the alert's action is called
        await alert.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)

        // THEN the AlertStatus has been set appropriately
        #expect(
            savedProject.alertStatus == .warning(warning: .directoryChanged)
        )
    }

    @Test("New Alert Status - Formats Changed - Editing")
    func newAlertStatusFormatsEditing() async throws {
        // GIVEN a ConfigureProjectViewModel for editing
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // GIVEN that our metric isn't miniLmAll
        #expect(
            testSubject.formatConfigurations != [
                .init(order: 1, format: .rtf, isEnabled: true),
                .init(order: 2, format: .md, isEnabled: true),
                .init(order: 3, format: .txt, isEnabled: true)
            ]
        )

        // WHEN we change the model to miniLmAll
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: true),
            .init(order: 3, format: .txt, isEnabled: true)
        ]

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN ReSync Alert is correctly set
        let alert = try #require(
            try await testSubject.$alertConfiguration.firstCompactValue()
        )

        // WHEN the alert's action is called
        await alert.primaryAction?.onSelect()

        // THEN the Project & Settings is saved
        let savedProjects = try await persistenceService.getProjects()
            .firstCompactValue()

        // THEN there is only one project in the DB
        #expect(savedProjects.count == 1)

        let savedProject = try #require(savedProjects.first)

        // THEN the AlertStatus has been set appropriately
        #expect(
            savedProject.alertStatus == .warning(warning: .formatsChanged)
        )
    }

    @Test(
        "Help Button Selected",
        arguments: ConfigureProjectViewModel.HelpType.allCases
    )
    func helpButtonEmbeddedSelected(
        type: ConfigureProjectViewModel.HelpType
    ) async throws {
        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // WHEN the help button is selected
        testSubject.helpButtonSelected(with: type)

        // THEN the help configuration is set
        let helpConfiguration = try #require(testSubject.helpConfiguration)

        // THEN the help configuration has the correct content
        let title = self.helpConfigurationTitle(for: type)
        let content = self.helpConfigurationContent(for: type)
        #expect(helpConfiguration.title == title)
        #expect(helpConfiguration.content == content)

        // WHEN the help configurations close-button is selected
        helpConfiguration.onDismiss()

        // THEN we don't have any help configuration on our test subject
        #expect(testSubject.helpConfiguration == nil)
    }

    @Test("Add and Remove Formats")
    func addAndRemoveFormats() async {
        typealias Format = ConfigureProjectViewModel.FormatConfiguration

        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        let rtf = Format(order: 0, format: .rtf, isEnabled: true)
        let txt = Format(order: 1, format: .txt, isEnabled: true)
        let html = Format(order: 2, format: .html, isEnabled: true)
        let md = Format(order: 3, format: .md, isEnabled: true)
        let pdf = Format(order: 4, format: .pdf, isEnabled: true)
        let word = Format(order: 5, format: .word, isEnabled: true)

        // THEN we have all our FormatConfigurations
        #expect(
            testSubject.formatConfigurations == [
                rtf, txt, html, md, pdf, word
            ]
        )

        // WHEN we set the .txt to false
        testSubject.set(
            formatConfiguration: txt,
            isEnabled: false
        )

        // WHEN we set the rtf to false
        testSubject.set(
            formatConfiguration: rtf,
            isEnabled: false
        )

        // THEN the ViewModel has it's format configurations correctly set
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: false),
                .init(order: 1, format: .txt, isEnabled: false),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true)
            ]
        )

        // WHEN we set rtf back to true
        testSubject.set(
            formatConfiguration: rtf,
            isEnabled: true
        )

        // THEN that is seen in the ViewModel
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: false),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true)
            ]
        )
    }

    @Test("Add and Remove Other Formats")
    func addAndRemoveOtherFormats() async {
        typealias Format = ConfigureProjectViewModel.FormatConfiguration

        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        let rtf = Format(order: 0, format: .rtf, isEnabled: true)
        let txt = Format(order: 1, format: .txt, isEnabled: true)
        let html = Format(order: 2, format: .html, isEnabled: true)
        let md = Format(order: 3, format: .md, isEnabled: true)
        let pdf = Format(order: 4, format: .pdf, isEnabled: true)
        let word = Format(order: 5, format: .word, isEnabled: true)

        // THEN we have all our FormatConfigurations
        #expect(
            testSubject.formatConfigurations == [
                rtf, txt, html, md, pdf, word
            ]
        )

        // WHEN we add an "other" format
        let other = testSubject.createNewFormat()

        // WHEN we give it a name
        testSubject.update(formatConfiguration: other, otherStr: "foo")

        // THEN the ViewModel has it's format configurations correctly set
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: true),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true),
                .init(order: 6, format: .other(".foo"), isEnabled: true)
            ]
        )

        // WHEN we add in another "other" format
        let another = testSubject.createNewFormat()

        // WHEN we give it a name
        testSubject.update(formatConfiguration: another, otherStr: "bar")

        // THEN the ViewModel has it's format configurations correctly set
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: true),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true),
                .init(order: 6, format: .other(".foo"), isEnabled: true),
                .init(order: 7, format: .other(".bar"), isEnabled: true)
            ]
        )

        // WHEN we delete the first other format
        testSubject.remove(formatConfiguration: other)

        // THEN the ViewModel has it's format configurations correctly set
        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: true),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true),
                .init(order: 7, format: .other(".bar"), isEnabled: true)
            ]
        )
    }

    @Test("No Directory Selected")
    func noDirectorySelected() async throws {
        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // WHEN we select a `nil` directory
        testSubject.directorySelected(nil)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to get folder access",
                message: "Please ensure that a project directory has been selected."
            )
        )
    }

    @Test("Invalid Directory Selected")
    func invalidDirectorySelected() async throws {
        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // WHEN an invalid URL is selected
        let testURL = URL(fileURLWithPath: "/foo/bar/foobar")
        testSubject.directorySelected(testURL)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to get folder access",
                message: "The file “foobar” couldn’t be opened because there is no such file."
            )
        )
    }

    @Test("Directory Selected")
    func directorySelected() async throws {
        // GIVEN a ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // Let's create a directory to call our own
        let testURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project")
        try FileManager.default.createDirectory(
            at: testURL,
            withIntermediateDirectories: true
        )

        // WHEN a URL is selected
        testSubject.directorySelected(testURL)

        // THEN we do not get an alert
        #expect(testSubject.alertConfiguration == nil)

        // THEN our ProjectDirectory is updated
        #expect(testSubject.projectDirectory == testURL)

        // THEN our ProjectDirectoryText is updated
        #expect(testSubject.projectDirectoryText == testURL.path())

        // THEN our ProjectName is correctly set
        #expect(testSubject.projectName == "test-project")

        // THEN our ProjectDirectoryData is not empty or nil
        #expect(testSubject.projectDirectoryBookmarkData?.isEmpty == false)
    }

    @Test("Default Values")
    func defaultValues() async {
        // GIVEN we have a brand new ConfigureProjectViewModel
        let testSubject = await self.mockForCreating()

        // THEN all of the default values are correctly set
        #expect(testSubject.projectInfo == nil)
        #expect(testSubject.projectDirectory == nil)
        #expect(testSubject.projectDirectoryText == "Select a Directory")
        #expect(testSubject.projectName == "")
        #expect(testSubject.selectedLanguage == .english)
        #expect(testSubject.selectedModel != nil)

        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: true),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: true),
                .init(order: 5, format: .word, isEnabled: true)
            ]
        )

        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)

        #expect(testSubject.systemPrompt == self.defaultSystemPrompt)
        #expect(testSubject.seed == 1234)
        #expect(testSubject.topK == 40)
        #expect(testSubject.topP == 0.9)

        #expect(testSubject.temperature == 0.2)
        #expect(testSubject.stopSequence == "")
        #expect(testSubject.maxTokenCount == 1048576)
        #expect(testSubject.strictMode == false)
        #expect(testSubject.availableModels.count == 1)
        #expect(testSubject.availableLanguages == ProjectSettings.Language.allCases)
        #expect(testSubject.availableEmbeddingModels == ProjectSettings.EmbeddingModel.allCases)
        #expect(testSubject.availableSimilarityMetrics == ProjectSettings.SimilarityMetric.allCases)
        #expect(testSubject.onOpen.value == nil)
        #expect(testSubject.alertConfiguration == nil)
        #expect(testSubject.helpConfiguration == nil)
    }

    @Test("Load Values from Project and Settings")
    func loadValues() async throws {
        // GIVEN we have an existing ConfigureProjectViewModel
        let testSubject = try await self.mockForEditing()
        testSubject.configureBindingsIfNeeded()

        // THEN all of the default values are correctly set
        #expect(testSubject.projectInfo != nil)
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: "/Users/will/Desktop/Project_1"))
        #expect(testSubject.projectDirectoryText == "/Users/will/Desktop/Project_1")
        #expect(testSubject.projectName == "Project 1")
        #expect(testSubject.selectedLanguage == .english)
        #expect(testSubject.selectedModel != nil)

        #expect(
            testSubject.formatConfigurations == [
                .init(order: 0, format: .rtf, isEnabled: true),
                .init(order: 1, format: .txt, isEnabled: true),
                .init(order: 2, format: .html, isEnabled: true),
                .init(order: 3, format: .md, isEnabled: true),
                .init(order: 4, format: .pdf, isEnabled: false),
                .init(order: 5, format: .word, isEnabled: false)
            ]
        )

        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)

        #expect(testSubject.systemPrompt == "You are a good bot")
        #expect(testSubject.seed == 1024)
        #expect(testSubject.topK == 40)
        #expect(testSubject.topP == 0.2)

        #expect(testSubject.temperature == 0.2)
        #expect(testSubject.stopSequence == nil)
        #expect(testSubject.maxTokenCount == 1024)
        #expect(testSubject.strictMode == false)
        #expect(testSubject.availableModels.count == 1)
        #expect(testSubject.availableLanguages == ProjectSettings.Language.allCases)
        #expect(testSubject.availableEmbeddingModels == ProjectSettings.EmbeddingModel.allCases)
        #expect(testSubject.availableSimilarityMetrics == ProjectSettings.SimilarityMetric.allCases)
        #expect(testSubject.onOpen.value == nil)
        #expect(testSubject.alertConfiguration == nil)
        #expect(testSubject.helpConfiguration == nil)

    }

    @Test("FormValidationError Descriptions")
    func formValidationErrorDescriptions() {
        typealias Error = ConfigureProjectViewModel.FormValidationError

        #expect(Error.missingDirectory.description == "Please ensure that a project directory has been selected.")
        #expect(Error.missingDirectoryData.description == "No secure directory data is avaiable to DocuBot.")
        #expect(Error.missingName.description == "Please ensure that a project name has been provided.")
        #expect(Error.missingModel.description == "Please ensure that a model has been selected.")
        #expect(Error.missingFormat.description == "Please ensure that at least one format has been enabled.")
        #expect(Error.missingSeed.description == "Please ensure that a valid seed value is provided.")
        #expect(Error.missingTopK.description == "Please ensure that a valid Top-K value is provided.")
        #expect(Error.missingMaxTokenCount.description == "Please ensure that a valid maximum token count is provided.")
        #expect(Error.missingSystemPrompt.description == "Please ensure that a valid system prompt is provided.")
        #expect(
            Error.invalidTopP.description == "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
        )
    }

}

// MARK: - Private

private extension ConfigureProjectViewModelTests {

    var defaultSystemPrompt: String {
        """
        You are a helpful assistant named DocuBot. DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries. You have been trained on a directory that contains the relevant documentation. You are expected to answer the user's questions to their code base. If you don't know the answer, simply say that. Avoid long paragraphs and break them up with newlines if need be. All responses you generate should be formatted in Markdown. Use `#` for headers, `*` or `-` for bullet points, and backticks (`) for inline code and code blocks. Include links using [text](URL) format.
        """
    }

    func helpConfigurationTitle(
        for type: ConfigureProjectViewModel.HelpType
    ) -> String {
        switch type {
        case .embeddingModel:
            return "What does the embedding model do?"
        case .similarityMetric:
            return "What does the similarity metric do?"
        case .seed:
            return "What does seed do?"
        case .topK:
            return "What does top-k do?"
        case .topP:
            return "What does top-p do?"
        case .temperature:
            return "What does temperature do?"
        case .stopSequence:
            return "What does stop sequence do?"
        case .maxTokenCount:
            return "What does max token count do?"
        case .systemPrompt:
            return "What does system prompt do?"
        case .strictMode:
            return "What does strict mode do?"
        }
    }

    func helpConfigurationContent(
        for type: ConfigureProjectViewModel.HelpType
    ) -> String {
        switch type {
        case .embeddingModel:
            return "An embedding model transforms input data (like text) into numerical vectors that represent the semantic meaning of the data.\n\nThese embeddings are used to measure relationships and similarities between different pieces of content, allowing the model to understand the context and meaning of the input.\n\nDistilBERT is a small version of the BERT model that has been fine tuned for question & answers.\nMiniLM All, is a smaller model, but it is much faster.\nMulti-QA MiniLM is a small & fast model that has been fine tuned for question & answering."
        case .similarityMetric:
            return "A similarity metric is a mathematical function used to compare the embeddings of two pieces of data.\n\nIt helps quantify how closely related two inputs are. Common similarity metrics include cosine similarity, which measures the angle between two vectors, and Euclidean distance, which measures the straight-line distance between them."
        case .seed:
            return "The seed value is used to initialise the random number generator, which influences how the model generates text.\n\nBy setting a seed, you ensure that the generation process is deterministic - running the same input with the same seed will result in the same output. This is useful for reproducibility."
        case .topK:
            return "Top-K sampling limits the model to choosing from only the top K most likely next tokens (words, subwords, etc.).\n\nBy default, K is set to 40, meaning the model will only consider the 40 most probable next tokens, adding an element of randomness while ensuring more likely tokens are preferred."
        case .topP:
            return "Top-P sampling (also known as nucleus sampling) dynamically selects the smallest possible set of tokens whose cumulative probability exceeds P.\n\nBy default, P is 0.9, so the model will sample from the top 90 percent of the probability mass, making it more flexible than top-K and helping balance between randomness and determinism in the generation."
        case .temperature:
            return "Temperature controls the \"creativity\" or randomness of the output.\n\nA lower temperature (e.g., 0.2) makes the model more conservative and focused on high-probability tokens, leading to more predictable and repetitive outputs. A higher temperature makes the model more creative and prone to selecting less likely tokens."
        case .stopSequence:
            return "If a stop sequence is specified, the generation will stop when the model generates the provided string sequence.\n\nThis is useful when you want to halt the model’s output after a certain phrase or token appears. If set to blank, the model will continue generating text until it reaches the maximum token limit or another stopping condition."
        case .maxTokenCount:
            return "This sets the maximum number of tokens the model is allowed to generate.\n\nEven if the model hasn’t hit a stopping condition (such as a stop sequence), it will stop once it generates the specified amount of tokens."
        case .systemPrompt:
            return "A system message provides background context or guidance to the model to help it generate appropriate responses.\n\nIt defines the model’s role, tone, and behavior. For example, a system message might instruct the model to act as a helpful assistant, limiting its answers to a specific knowledge domain."
        case .strictMode:
            return "Strict Mode ensures that DocuBot returns only the content from the documentation without additional commentary or elaboration from the AI model.\n\nIn this mode, the LLM will be disabled, and the response will strictly repeat excerpts from the provided documentation."
        }
    }

    // swiftlint:enable line_length
}  // swiftlint:disable:this file_length
