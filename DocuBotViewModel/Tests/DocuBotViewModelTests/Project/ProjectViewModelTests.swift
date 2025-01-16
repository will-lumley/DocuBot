//
//  ProjectViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 10/12/2024.
//

import DocuBotModel
import DocuBotService
@testable import DocuBotViewModel
import Testing

@Suite("ProjectViewModelTests", .tags(.view))
class ProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Labels")
    func labels() {
        // GIVEN we have a ProjectViewModel
        let testSubject = ProjectViewModel(
            project: .mock(
                name: "Cool Project Name"
            ),
            serviceContainer: serviceContainer
        )

        // THEN our labels are all in order
        #expect(testSubject.windowTitle == "Cool Project Name")
        #expect(testSubject.queryTitle == "Ask any question about your project.")
        #expect(testSubject.textEditorPlaceholder == "Write your question here...")
        #expect(testSubject.shareButtonTitle == "Share")
    }

    @Test("Button Initial States")
    func buttonInitialStates() {
        // GIVEN we have a ProjectViewModel
        let testSubject = ProjectViewModel(
            project: .mock(
                alertStatus: .none
            ),
            serviceContainer: serviceContainer
        )

        // THEN our buttons are all configured correctly
        #expect(
            testSubject.sourcesButton == .init(
                name: "Sources",
                symbol: .docTextMagnifyingglass,
                isEnabled: false
            )
        )
        #expect(
            testSubject.syncProjectButton == .init(
                name: "Sync",
                symbol: .arrowTriangle2Circlepath
            )
        )
        #expect(
            testSubject.projectSettingsButton == .init(
                name: "Settings",
                symbol: .gear
            )
        )

    }

    @Test("LLM is Primed")
    func llmIsPrimed() async throws {
        let mockGptService = try #require(
            serviceContainer.gptService as? MockGPTService
        )
        mockGptService.primeResponse = .content

        var primedIterator = mockGptService.primePublisher.values.makeAsyncIterator()

        // GIVEN we have a ProjectViewModel
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        _ = try await self.mock(project, model, settings)

        // THEN our prime state is at first `nil`
        var next = try #require(try await primedIterator.next())
        #expect(next == nil)

        // THEN our next prime state is one with the model and settings in our Project
        next = try #require(try await primedIterator.next())
        #expect(next?.model == model)
        #expect(next?.settings == settings)
    }

    @Test(
        "LLM Prime Fails",
        .disabled(),
        arguments: GPTError.allCases
    )
    func llmPrimeFails(with gptError: GPTError) async throws {
        let mockGptService = try #require(
            serviceContainer.gptService as? MockGPTService
        )
        mockGptService.primeResponse = .error(gptError)

        var primedIterator = mockGptService.primePublisher.values.makeAsyncIterator()

        // GIVEN we have a ProjectViewModel
        let project = Project.mock(id: 1)
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(project, model, settings)

        // THEN our prime state is `nil`
        let nextPrime = try #require(try await primedIterator.next())
        #expect(nextPrime == nil)

        var alertIterator = testSubject.$alertConfiguration.values.makeAsyncIterator()

        // THEN we have an alert that is nil
        var nextAlert = try #require(try await alertIterator.next())
        #expect(nextAlert == nil)
    }

    @Test("Open Setttings")
    func openSettings() {
        // Intentionally left blank.
    }

    @Test("Enter Selected")
    func enterSelected() {
        // Intentionally left blank.
    }

    @Test("Example Question Selected")
    func exampleQuestionSelected() {
        // Intentionally left blank.
    }

    @Test("Directory Selected")
    func directorySelected() {
        // Intentionally left blank.
    }

    @Test("Ask Button Selected - Start")
    func startAskButtonSelected() {
        // Intentionally left blank.
    }

    @Test("Ask Button Selected - Stop")
    func stopAskButtonSelected() {
        // Intentionally left blank.
    }

    @Test("Build Example Questions")
    func buildExampleQuestions() {
        // Intentionally left blank.
    }

    @Test("Build Alert Status")
    func buildAlertStatus() {
        // Intentionally left blank.
    }

    @Test("Alert Status Icon on Sync Button")
    func alertStatusIconOnSyncButton() {
        // Intentionally left blank.
    }

    @Test("Alert Status Color on Sync Button")
    func alertStatusColorOnSyncButton() {
        // Intentionally left blank.
    }

    @Test("View Sources Button - Disabled - Syncing")
    func viewSourcesButtonDisabledSyncing() {
        // Intentionally left blank.
    }

    @Test("View Sources Button - Disabled - No Sources")
    func viewSourcesButtonDisabledNoSources() {
        // Intentionally left blank.
    }

    @Test("View Sources Button - Enabled")
    func viewSourcesButtonEnabledNoSources() {
        // Intentionally left blank.
    }

    @Test("Sync Button - Disabled - Syncing")
    func syncButtonDisabledWhenSyncing() {
        // Intentionally left blank.
    }

    @Test("Settings Button - Disabled - Syncing")
    func settingsButtonDisabledWhenSyncing() {
        // Intentionally left blank.
    }

    @Test("Text View - Disabled - Syncing")
    func disableTextViewWhenSyncing() {
        // Intentionally left blank.
    }

    @Test("Text View - Disabled - Error")
    func disableTextViewWhenError() {
        // Intentionally left blank.
    }

    @Test("Ask Button Title - Expecting Response")
    func askButtonTitleExpectingResponse() {
        // Intentionally left blank.
    }

    @Test("Ask Button Title - Not Expecting Response")
    func askButtonTitleNotExpectingResponse() {
        // Intentionally left blank.
    }

    @Test("Ask Button Icon - Expecting Response")
    func askButtonIconExpectingResponse() {
        // Intentionally left blank.
    }

    @Test("Ask Button Icon - Not Expecting Response")
    func askButtonIconNotExpectingResponse() {
        // Intentionally left blank.
    }

    @Test("Share Button - Disabled - No Share Content")
    func shareButtonDisabledNoShareContent() {
        // Intentionally left blank.
    }

    @Test("Share Button - Disabled - Expecting Response")
    func shareButtonDisabledExpectingResponse() {
        // Intentionally left blank.
    }

    @Test("Response Feeds Into Share Content")
    func responseIsShareContent() {
        // Intentionally left blank.
    }

}

// MARK: - Private

private extension ProjectViewModelTests {

    func mock(
        _ project: Project = .mock(id: 1),
        _ model: LLMModel = .mock(id: 1),
        _ settings: ProjectSettings = .mock(projectID: 1, modelID: 1)
    ) async throws -> ProjectViewModel {
        _ = try await persistenceService.insert(model: model)
        let insertedProject = try await persistenceService.insert(project: project)
        _ = try await persistenceService.insert(settings: settings)

        return ProjectViewModel(
            project: insertedProject,
            serviceContainer: serviceContainer
        )
    }

}
