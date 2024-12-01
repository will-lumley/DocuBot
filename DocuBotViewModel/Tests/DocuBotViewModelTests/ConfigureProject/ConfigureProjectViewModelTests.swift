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

@Suite("ConfigureProjectViewModelTests", .serialized)
class ConfigureProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable { // swiftlint:disable:this type_body_length

    @Test("Label Values")
    func labelValues() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN we have a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

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
        #expect(testSubject.contextLengthTitle == "Context Length")
        #expect(testSubject.contextLengthTitle == "Context Length")
        #expect(testSubject.temperatureTitle == "Temperature")
        #expect(testSubject.batchSizeTitle == "Batch Size")
        #expect(testSubject.stopSequenceTitle == "Stop Sequence")
        #expect(testSubject.maxTokenCountTitle == "Maximum Token Count")
        #expect(testSubject.strictModeTitle == "Strict Mode")
        #expect(testSubject.resetDefaultButtonTitle == "Reset Default Values")
    }

    @Test("Initialisation - Creating")
    func initialisationCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a new ConfigureProjectViewModel for creating a project
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // THEN properties are set to default values
        #expect(testSubject.projectInfo == nil)
        #expect(testSubject.projectDirectory == nil)
        #expect(testSubject.projectName == "")
        #expect(testSubject.selectedLanguage == .english)
        #expect(testSubject.embeddingModel == .distilbert)
        #expect(testSubject.similarityMetric == .cosine)
        #expect(testSubject.contextLength == 2048)
    }

    @Test("Initialisation - Editing")
    func initialisationEditing() async {
        // GIVEN a mock ProjectInfo
        let projectInfo = ConfigureProjectViewModel.ProjectInfo(
            project: Project.mock(),
            settings: ProjectSettings.mock()
        )

        // WHEN we initialise the ConfigureProjectViewModel for editing
        let testSubject = ConfigureProjectViewModel(
            projectInfo: projectInfo,
            serviceContainer: self.serviceContainer
        )

        // THEN properties are set based on the ProjectInfo
        #expect(testSubject.projectInfo != nil)
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: projectInfo.project.path))
        #expect(testSubject.projectName == projectInfo.project.name)
        #expect(testSubject.selectedLanguage == projectInfo.settings.language)
        #expect(testSubject.embeddingModel == projectInfo.settings.embeddingModel)
        #expect(testSubject.similarityMetric == projectInfo.settings.similarityMetric)
    }

    @Test("Project Directory Text")
    func projectDirectoryText() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN we have our ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )
        testSubject.configureBindingsIfNeeded()

        // THEN our ProjectDirectoryText is empty
        #expect(testSubject.projectDirectoryText == "Select a Directory")

        // WHEN we set the ProjectDirectory URL
        testSubject.projectDirectory = URL(string: "/example/path-to-project")

        // THEN our ProjectDirectoryText is correctly set
        #expect(testSubject.projectDirectoryText == "/example/path-to-project")
    }

    @Test("Form Title - Creating")
    func formTitleCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // WHEN we initialise the ConfigureProjectViewModel for editing
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // THEN the form title is correctly set
        #expect(testSubject.formTitle == L10n.ConfigureProject.Creating.formTitle)
    }

    @Test("Form Title - Editing")
    func formTitleEditing() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a mock ProjectInfo
        let projectInfo = ConfigureProjectViewModel.ProjectInfo(
            project: Project.mock(),
            settings: ProjectSettings.mock()
        )

        // WHEN we initialise the ConfigureProjectViewModel for editing
        let testSubject = ConfigureProjectViewModel(
            projectInfo: projectInfo,
            serviceContainer: self.serviceContainer
        )

        // THEN the form title is correctly set
        #expect(testSubject.formTitle == L10n.ConfigureProject.Editing.formTitle)
    }

    @Test("Save Button Title - Creating")
    func saveButtonTitleCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // WHEN we initialise the ConfigureProjectViewModel for editing
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // THEN the form title is correctly set
        #expect(testSubject.saveButtonTitle == L10n.ConfigureProject.Creating.createButton)
    }

    @Test("Save Button Title - Editing")
    func saveButtonTitleEditing() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a mock ProjectInfo
        let projectInfo = ConfigureProjectViewModel.ProjectInfo(
            project: Project.mock(),
            settings: ProjectSettings.mock()
        )

        // WHEN we initialise the ConfigureProjectViewModel for editing
        let testSubject = ConfigureProjectViewModel(
            projectInfo: projectInfo,
            serviceContainer: self.serviceContainer
        )

        // THEN the form title is correctly set
        #expect(testSubject.saveButtonTitle == L10n.ConfigureProject.Editing.createButton)
    }

    @Test("Form Validation - Creating - Missing Directory")
    func formValidationCreatingMissingDirectory() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a project directory has been selected."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Directory Data")
    func formValidationCreatingMissingDirectoryData() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not the secure URL data
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "No secure directory data is avaiable to DocuBot."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Name")
    func formValidationCreatingMissingName() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not the project name
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a project name has been provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Format")
    func formValidationCreatingMissingFormat() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our format types
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: false)]

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that at least one format has been enabled."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Seed")
    func formValidationCreatingMissingSeed() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our seed
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid seed value is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing TopK")
    func formValidationCreatingMissingTopK() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our TopK
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid Top-K value is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Invalid TopP - Lower Bounds")
    func formValidationCreatingInvalidTopPLower() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = -1

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Invalid TopP - Upper Bounds")
    func formValidationCreatingInvalidTopPUpper() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = 11

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Context Length")
    func formValidationCreatingMissingContextLength() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Context Length
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid context length is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Batch Size")
    func formValidationCreatingMissingBatchSize() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Batch Size
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid batch size is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing Token Count")
    func formValidationCreatingMissingTokenCount() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid maximum token count is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Creating - Missing System Prompt")
    func formValidationCreatingMissingSystemPrompt() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = ""

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Create Project",
                            message: "Please ensure that a valid system prompt is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Directory")
    func formValidationEditingMissingDirectory() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not the project directory
        testSubject.projectDirectory = nil

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a project directory has been selected."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Directory Data")
    func formValidationEditingMissingDirectoryData() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not the secure URL data
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = nil

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "No secure directory data is avaiable to DocuBot."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Name")
    func formValidationEditingMissingName() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not the project name
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = ""

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a project name has been provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Format")
    func formValidationEditingMissingFormat() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our format types
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: false)]

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that at least one format has been enabled."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Seed")
    func formValidationEditingMissingSeed() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our seed
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid seed value is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing TopK")
    func formValidationEditingMissingTopK() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our TopK
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid Top-K value is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Invalid TopP - Lower Bounds")
    func formValidationEditingInvalidTopPLower() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = -1

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
                        )
                    )
                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Invalid TopP - Upper Bounds")
    func formValidationEditingInvalidTopPUpper() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not a valid input for our TopP
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 10
        testSubject.topP = 11

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Context Length")
    func formValidationEditingMissingContextLength() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Context Length
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid context length is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Batch Size")
    func formValidationEditingMissingBatchSize() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Batch Size
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid batch size is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing Token Count")
    func formValidationEditingMissingTokenCount() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our Token Count
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 0

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid maximum token count is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Form Validation - Editing - Missing System Prompt")
    func formValidationEditingMissingSystemPrompt() async throws {
        var cancellables = [AnyCancellable]()

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we ensure we have filled out some of the details, but not our system prompt
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = ""

        // WHEN we validate the form
        await testSubject.saveButtonSelected()

        // THEN the correct error is shown
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration
                .compactMap(\.self)
                .sink { newValue in
                    #expect(
                        newValue == .init(
                            title: "Failed to Update Project",
                            message: "Please ensure that a valid system prompt is provided."
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }
    }

    @Test("Save Project - Creating")
    func createProject() async throws {
        var cancellables = [AnyCancellable]()

        var onSavedCalled = false

        // Ensure that there is no Projects in the DB
        let allProjects = try await persistenceService.getProjects()
        #expect(allProjects.count == 0)

        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with no existing Project
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        ) {
            onSavedCalled = true
        }

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
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.stopSequence = "abc"
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"
        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance
        testSubject.strictMode = true

        // WHEN we save the Project
        await testSubject.saveButtonSelected()

        // THEN a new Project has been created on the DB
        var newProject: Project!
        await withCheckedContinuation { continuation in
            self.persistenceService.getProjects()
                .replaceError(with: [])
                .sink { allProjects in
                    // THEN there is only one newly create Project
                    #expect(allProjects.count == 1)
                    newProject = allProjects.first!

                    // THEN the Project has the correct attributes
                    #expect(newProject.id == 1)
                    #expect(newProject.path == "/example/path")
                    #expect(newProject.name == "Test Name")
                    #expect(newProject.urlBookmarkData == Data())
                    #expect(newProject.documentationChecksum == nil)
                    #expect(newProject.exampleQuestions == [])
                    #expect(newProject.alertStatus == .error(error: .firstSync))
                    #expect(newProject.needsFullResync == true)
                    #expect(
                        newProject.createdAt.secondsFrom1970 == Date.now.secondsFrom1970
                    )
                    #expect(
                        newProject.updatedAt.secondsFrom1970 == Date.now.secondsFrom1970
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }

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
        #expect(settings.batchSize == 15)
        #expect(settings.stopSequence == "abc")
        #expect(settings.maxTokenCount == 1024)
        #expect(settings.systemPrompt == "This is a system prompt")
        #expect(settings.strictMode == true)

        // THEN we've opened up our Project's new window
        let newWindow = try #require(testSubject.onOpen.value)
        #expect(
            newWindow == .project(
                .init(project: newProject)
            )
        )

        // THEN onSave has been called
        #expect(onSavedCalled == true)
    }

    @Test("Save Project - Editing")
    func editProject() async throws {
        var cancellables = [AnyCancellable]()

        var onSavedCalled = false

        // Ensure that there is no Projects in the DB
        let allProjects = try await persistenceService.getProjects()
        #expect(allProjects.count == 0)

        // Load a testing model into our DB
        await self.persistTestModel()

        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)

        // GIVEN that we have an existing Project & Settings in the DB
        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(
                project: project,
                settings: settings
            ),
            serviceContainer: self.serviceContainer
        ) {
            onSavedCalled = true
        }

        // WHEN we ensure we have filled out all of the details
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.model = .mock(id: 1)
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"
        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance
        testSubject.strictMode = true

        // WHEN we save the Project
        await testSubject.saveButtonSelected()

        // THEN a new Project has been created on the DB
        await withCheckedContinuation { continuation in
            self.persistenceService.getProjects()
                .replaceError(with: [])
                .sink { allProjects in
                    // THEN there is only one newly create Project
                    #expect(allProjects.count == 1)
                    let project = allProjects.first!

                    // THEN the Project has the correct attributes
                    #expect(project.id == 1)
                    #expect(project.path == "/example/path")
                    #expect(project.name == "Test Name")
                    #expect(project.urlBookmarkData == Data())
                    #expect(project.documentationChecksum == "123")
                    #expect(project.exampleQuestions == ["foo", "bar"])
                    #expect(project.alertStatus == .error(error: .firstSync))
                    #expect(project.needsFullResync == true)
                    #expect(
                        project.createdAt.secondsFrom1970 == Date.now.secondsFrom1970
                    )
                    #expect(
                        project.updatedAt.secondsFrom1970 == Date.now.secondsFrom1970
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)
        }

        // THEN a new ProjectSettings has been created on the DB
        let fetchedSettings = try await persistenceService.getProjectSettings(
            for: .mock(id: 1)
        )

        // THEN the ProjectSettings has the correct attributes
        #expect(fetchedSettings.id == 1)
        #expect(fetchedSettings.projectID == 1)
        #expect(fetchedSettings.modelID == 1)
        #expect(fetchedSettings.supportedFormats == [.rtf, .txt])
        #expect(fetchedSettings.language == .english)
        #expect(fetchedSettings.embeddingModel == .multiQaMiniLm)
        #expect(fetchedSettings.similarityMetric == .euclideanDistance)
        #expect(fetchedSettings.seed == 20)
        #expect(fetchedSettings.topK == 5)
        #expect(fetchedSettings.topP == 0.5)
        #expect(fetchedSettings.batchSize == 15)
        #expect(fetchedSettings.maxTokenCount == 1024)
        #expect(fetchedSettings.systemPrompt == "This is a system prompt")
        #expect(fetchedSettings.strictMode == true)

        // THEN onSave has been called
        #expect(onSavedCalled == true)

        // THEN we haven't opened up any new window
        #expect(testSubject.onOpen.value == nil)
    }

    @Test("Reset LLM Options")
    func resetLlmOptions() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with custom LLM options
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.model = .mock(id: 1)
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.contextLength = 10
        testSubject.temperature = 15
        testSubject.batchSize = 15
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
        #expect(testSubject.contextLength == 2048)
        #expect(testSubject.temperature == 0.2)
        #expect(testSubject.batchSize == 2048)
        #expect(testSubject.stopSequence == "")
        #expect(testSubject.maxTokenCount == 1048576)
        #expect(testSubject.systemPrompt == "You are a helpful assistant named DocuBot. DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries. You have been trained on a directory that contains the relevant documentation. You are expected to answer the user's questions to their code base. If you don't know the answer, simply say that. Avoid long paragraphs and break them up with newlines if need be. All responses you generate should be formatted in Markdown. Use `#` for headers, `*` or `-` for bullet points, and backticks (`) for inline code and code blocks. Include links using [text](URL) format.") // swiftlint:disable:this line_length
        #expect(testSubject.strictMode == false)

        // THEN nothing else has been changed
        #expect(testSubject.projectName == "Test Name")
        #expect(testSubject.projectDirectory == URL(fileURLWithPath: "/example/path"))
        #expect(testSubject.embeddingModel == .multiQaMiniLm)
        #expect(testSubject.similarityMetric == .euclideanDistance)
    }

    @Test("Reset Similarity Options")
    func resetSimilarityOptions() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.model = .mock(id: 1)
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true),
            .init(order: 2, format: .md, isEnabled: false),
            .init(order: 2, format: .txt, isEnabled: true)
        ]
        testSubject.seed = 20
        testSubject.topK = 5
        testSubject.topP = 0.5
        testSubject.contextLength = 10
        testSubject.temperature = 15
        testSubject.batchSize = 15
        testSubject.stopSequence = "foobar"
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "This is a system prompt"

        testSubject.embeddingModel = .multiQaMiniLm
        testSubject.similarityMetric = .euclideanDistance

        // WHEN the resetLlmOptions method is called
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
        #expect(testSubject.contextLength == 10)
        #expect(testSubject.temperature == 15)
        #expect(testSubject.batchSize == 15)
        #expect(testSubject.stopSequence == "foobar")
        #expect(testSubject.maxTokenCount == 1024)
        #expect(testSubject.systemPrompt == "This is a system prompt")
        #expect(testSubject.strictMode == false)
    }

    @Test("ReSync Message - None - Creating")
    func noResyncMessageCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we have our details filled out
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Metric Changed - Creating")
    func resyncMessageMetricChangedCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the metric
        testSubject.similarityMetric = .dotProduct
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - EmbeddedModel Changed - Creating")
    func resyncMessageEmbeddedModelChangedCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the embedding model
        testSubject.embeddingModel = .miniLmAll
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Directory Changed - Creating")
    func resyncMessageDirectoryChangedCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the directory
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()
        testSubject.projectName = "Test Name"
        testSubject.formatConfigurations = [.init(order: 1, format: .rtf, isEnabled: true)]
        testSubject.seed = 10
        testSubject.topK = 5
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Formats Changed - Creating")
    func resyncMessageFormatsChangedCreating() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

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
        testSubject.contextLength = 10
        testSubject.batchSize = 15
        testSubject.maxTokenCount = 1024
        testSubject.systemPrompt = "Test"

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - None - Editing")
    func noResyncMessageEditing() async throws {
        var cancellables = [AnyCancellable]()

        // GIVEN that we have an existing Project & Settings in the DB
        let model = await self.persistTestModel()
        let modelID = try model.id.orThrow(LLMModel.ModelError.missingID)
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(
            id: 1,
            projectID: 1,
            modelID: modelID
        )

        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(
                project: project,
                settings: settings
            ),
            serviceContainer: self.serviceContainer
        )

        // We need to wait for the model to be loaded before proceeding
        await withCheckedContinuation { continuation in
            testSubject.$model.eraseToAnyPublisher()
                .compactMap(\.self)
                .sink { bar in
                    continuation.resume()
                }
                .store(in: &cancellables)
        }

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(testSubject.alertConfiguration == nil)
    }

    @Test("ReSync Message - Metric Changed - Editing")
    func resyncMessageMetricChangedEditing() async throws {
        var cancellables = [AnyCancellable]()

        let model = await self.persistTestModel()
        let modelID = try model.id.orThrow(LLMModel.ModelError.missingID)
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(
            id: 1,
            projectID: 1,
            modelID: modelID
        )

        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(
                project: project,
                settings: settings
            ),
            serviceContainer: self.serviceContainer
        )

        // We need to wait for the model to be loaded before proceeding
        await withCheckedContinuation { continuation in
            testSubject.$model.eraseToAnyPublisher()
                .compactMap(\.self)
                .sink { bar in
                    continuation.resume()
                }
                .store(in: &cancellables)
        }

        // WHEN we change the metric
        testSubject.similarityMetric = .dotProduct

        // THEN ReSync Alert is correctly set
        await withCheckedContinuation { continuation in
            testSubject.$alertConfiguration.eraseToAnyPublisher()
                .compactMap(\.self)
                .sink { newAlert in
                    #expect(
                        newAlert == .init(
                            title: "",
                            message: ""
                        )
                    )

                    continuation.resume()
                }
                .store(in: &cancellables)

            // WHEN we try and save the Project & Settings
            Task { await testSubject.saveButtonSelected() }
        }
    }

    @Test("ReSync Message - EmbeddedModel Changed - Editing")
    func resyncMessageEmbeddedModelChangedEditing() async throws {
        // GIVEN that we have an existing Project & Settings in the DB
        let model = await self.persistTestModel()
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: model.id ?? -1)

        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the embedding model
        testSubject.embeddingModel = .miniLmAll

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(
            testSubject.alertConfiguration == .init(
                title: "",
                message: ""
            )
        )
    }

    @Test("ReSync Message - Directory Changed - Editing")
    func resyncMessageDirectoryChangedEditing() async throws {
        // GIVEN that we have an existing Project & Settings in the DB
        let model = await self.persistTestModel()
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: model.id ?? -1)

        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the directory
        testSubject.projectDirectory = URL(fileURLWithPath: "/example/path")
        testSubject.projectDirectoryBookmarkData = Data()

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(
            testSubject.alertConfiguration == .init(
                title: "",
                message: ""
            )
        )
    }

    @Test("ReSync Message - Formats Changed - Editing")
    func resyncMessageFormatsChangedEditing() async throws {
        // GIVEN that we have an existing Project & Settings in the DB
        let model = await self.persistTestModel()
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: model.id ?? -1)

        _ = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        // GIVEN a ConfigureProjectViewModel with an existing Project
        let testSubject = ConfigureProjectViewModel(
            projectInfo: .init(project: .mock(), settings: .mock()),
            serviceContainer: self.serviceContainer
        )

        // WHEN we change the formats
        testSubject.formatConfigurations = [
            .init(order: 1, format: .rtf, isEnabled: true)
        ]

        // WHEN we try and save the Project & Settings
        await testSubject.saveButtonSelected()

        // THEN there is no ReSync Alert
        #expect(
            testSubject.alertConfiguration == .init(
                title: "",
                message: ""
            )
        )
    }

    @Test("New Alert Status")
    func newAlertStatus() async {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with an empty slate
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        
    }

    @Test("Help Button Selected")
    func helpButtonSelected() {
        // GIVEN a ConfigureProjectViewModel
//        let testSubject = ConfigureProjectViewModel(
//            serviceContainer: .mock
//        )
//
//        // WHEN the help button is selected
//        testSubject.helpButtonSelected(with: .embeddingModel)
//
//        // THEN the help configuration is set
//        #expect(testSubject.helpConfiguration != nil)
//        #expect(testSubject.helpConfiguration?.title == L10n.ConfigureProject.Help.embeddingModel)
    }

    @Test("Directory Selected")
    func directorySelected() {
        
    }

    @Test("Add and Remove Formats")
    func addAndRemoveFormats() {
//        // GIVEN a ConfigureProjectViewModel
//        let testSubject = ConfigureProjectViewModel(
//            serviceContainer: .mock
//        )
//
//        // WHEN a new format is added
//        testSubject.createNewFormat()
//        let addedFormatCount = testSubject.formatConfigurations.count
//
//        // AND the format is removed
//        let newFormat = testSubject.formatConfigurations.last!
//        testSubject.remove(formatConfiguration: newFormat)
//        let removedFormatCount = testSubject.formatConfigurations.count
//
//        // THEN the format is added and removed correctly
//        #expect(addedFormatCount == removedFormatCount + 1)
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
        #expect(Error.missingContextLength.description == "Please ensure that a valid context length is provided.")
        #expect(Error.missingBatchSize.description == "Please ensure that a valid batch size is provided.")
        #expect(Error.missingMaxTokenCount.description == "Please ensure that a valid maximum token count is provided.")
        #expect(Error.missingSystemPrompt.description == "Please ensure that a valid system prompt is provided.")
        #expect(
            Error.invalidTopP.description == "Please ensure that the Top-P value is within the range of 0.0 and 1.0."
        )
    }

    // swiftlint:enable line_length
} // swiftlint:disable:this file_length
