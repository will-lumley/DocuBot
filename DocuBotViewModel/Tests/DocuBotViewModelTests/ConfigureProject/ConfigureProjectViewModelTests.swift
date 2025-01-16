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

class ConfigureProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

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
        #expect(testSubject.formatSectionSubtitle == "We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later.")
        #expect(testSubject.similaritySectionTitle == "Similarity Metric Configuration")
        #expect(testSubject.similaritySectionSubtitle == "These options determine how the similarity between query inputs and documentation is calculated, affecting the accuracy of results. Adjust them only if you need something specific.\nChanging these will require a full resync of your project.")
        #expect(testSubject.embeddingModelTitle == "Embedding Model")
        #expect(testSubject.similarityMetricTitle == "Similarity Metric")
        #expect(testSubject.llmSectionTitle == "LLM Configuration")
        #expect(testSubject.llmSectionSubitle == "Adjust advanced settings for the LLM, including model parameters and behavior to optimise performance and responsiveness. Adjust them only if you need something specific.")

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()
        
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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()
        
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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
        testSubject.saveButtonSelected()

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
    func createProject() {
        
    }

    @Test("Save Project - Editing")
    func editProject() {
        
    }

    @Test("Reset LLM Options")
    func resetLlmOptions() {
//        // GIVEN a ConfigureProjectViewModel with custom LLM options
//        let testSubject = ConfigureProjectViewModel(
//            serviceContainer: .mock
//        )
//        testSubject.seed = 5678
//        testSubject.topK = 50
//        testSubject.temperature = 0.7
//
//        // WHEN the resetLlmOptions method is called
//        testSubject.resetLlmOptions()
//
//        // THEN the LLM options are reset to their default values
//        #expect(testSubject.seed == 1234)
//        #expect(testSubject.topK == 40)
//        #expect(testSubject.temperature == 0.2)
    }

    @Test("Reset Similarity Options")
    func resetSimilarityOptions() {
        
    }

    @Test("ReSync Message")
    func reSyncMessage() {
        
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
        #expect(Error.invalidTopP.description == "Please ensure that the Top-P value is within the range of 0.0 and 1.0.")
        #expect(Error.missingContextLength.description == "Please ensure that a valid context length is provided.")
        #expect(Error.missingBatchSize.description == "Please ensure that a valid batch size is provided.")
        #expect(Error.missingMaxTokenCount.description == "Please ensure that a valid maximum token count is provided.")
        #expect(Error.missingSystemPrompt.description == "Please ensure that a valid system prompt is provided.")
    }

}
