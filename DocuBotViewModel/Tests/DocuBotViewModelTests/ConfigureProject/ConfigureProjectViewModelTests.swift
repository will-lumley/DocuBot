//
//  ConfigureProjectViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Foundation
import Testing

class ConfigureProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

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

    @Test("Form Validation")
    func formValidation() async throws {
        // Load a testing model into our DB
        await self.persistTestModel()

        // GIVEN a ConfigureProjectViewModel with valid inputs
        let testSubject = ConfigureProjectViewModel(
            serviceContainer: self.serviceContainer
        )

        testSubject.projectDirectory = URL(fileURLWithPath: "/test/path")
        testSubject.projectName = "Test Project"

        // WHEN we validate the form
        testSubject.saveButtonSelected()

        // THEN the correct error is shown
//        #expect(
//            testSubject.alertConfiguration == .init(
//                title: "",
//                message: ""
//            )
//        )
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

}
