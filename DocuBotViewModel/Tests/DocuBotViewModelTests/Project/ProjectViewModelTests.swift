//
//  ProjectViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 10/12/2024.
//

import Combine
import DocuBotModel
import DocuBotService
@testable import DocuBotViewModel
import Foundation
import SFSafeSymbols
import Testing

@Suite(
    "ProjectViewModelTests",
    .tags(.view),
    .serialized,
    .timeLimit(.minutes(1))
)
// swiftlint:disable:next type_body_length
class ProjectViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    // MARK: - Properties

    /// The MockGPTService that we'll be using for our tests
    private var mockGptService: MockGPTService!

    /// The project that was created for our mock `ProjectViewModel`
    private var project: Project?

    /// Storage for our subscriptions
    var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override init() {
        super.init()
        self.mockGptService = serviceContainer.gptService as? MockGPTService
        self.mockGptService.primeResponse = .content
    }

    // MARK: - Tests

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
        var primedIterator = mockGptService.primePublisher
            .values
            .makeAsyncIterator()

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
        .serialized,
        arguments: GPTError.allCases
    )
    func llmPrimeFails(with gptError: GPTError) async throws {
        mockGptService.primeResponse = .error(gptError)

        var primedIterator = mockGptService.primePublisher
            .values
            .makeAsyncIterator()

        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)

        var alertIterator = testSubject.$alertConfiguration
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // THEN our prime state is `nil`
        let nextPrime = try #require(try await primedIterator.next())
        #expect(nextPrime == nil)

        // THEN we have an alert that is nil
        var nextAlert = try #require(await alertIterator.next())
        #expect(nextAlert == nil)

        // THEN we have an alert about the LLM Prime failing
        nextAlert = try #require(await alertIterator.next())
        #expect(
            nextAlert == .init(
                title: "Failed to initialise LLM",
                message: self.errorMessage(for: gptError)
            )
        )
    }

    @Test("Open Setttings")
    func openSettings() async throws {
        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)

        let project = try #require(self.project)

        var configureIterator = testSubject.$configureProjectViewModel
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // WHEN we select the Settings button
        testSubject.projectSettingsButton.onSelect()

        // THEN at first our ConfigureProject was nil
        var configureProjectViewModel = try #require(
            await configureIterator.next()
        )
        #expect(configureProjectViewModel == nil)

        // THEN our ConfigureProject exists
        configureProjectViewModel = try #require(await configureIterator.next())

        let expectedProject = try #require(
            configureProjectViewModel?.projectInfo?.project
        )
        let expectedSettings = try #require(
            configureProjectViewModel?.projectInfo?.settings
        )

        // THEN our ConfigureProject was passed the correct Project & Settings
        #expect(expectedProject == project)
        #expect(expectedSettings == settings)

        // THEN our ConfigureProject has been passed our model
        #expect(configureProjectViewModel?.availableModels == [model])
    }

    @Test("Open Settings - Prime on Closed")
    func openSettingsPrimeOnClosed() async throws {
        // Let's listen to our Prime on our GPTService
        var primeIterator = mockGptService.primePublisher
            .values
            .makeAsyncIterator()

        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)
        testSubject.configureBindingsIfNeeded()

        var configureIterator = testSubject.$configureProjectViewModel
            .values
            .makeAsyncIterator()

        // THEN we get our first Prime values
        var nextPrimeValue = try #require(await primeIterator.next())
        nextPrimeValue = try #require(await primeIterator.next())

        // WHEN we select the Settings button
        testSubject.projectSettingsButton.onSelect()

        // THEN at first our ConfigureProject was nil
        var configureProjectViewModel = try #require(await configureIterator.next())
        #expect(configureProjectViewModel == nil)

        // THEN our ConfigureProject exists
        configureProjectViewModel = try #require(await configureIterator.next())

        // WHEN we listen in on our ConfigureProject OnSave
        configureProjectViewModel?.onSave?()

        // THEN we get primed with the right settings
        nextPrimeValue = try #require(await primeIterator.next())
        #expect(nextPrimeValue?.settings == settings)
    }

    @Test("Open Settings - Fail")
    func openSettingsFail() async throws {
        mockGptService.primeResponse = .content

        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(id: 1, projectID: 1, modelID: 1)
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)

        var alertIterator = testSubject.$alertConfiguration
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // THEN we wait for the LLM to prime
        try await Task.sleep(for: .seconds(1))

        // THEN we delete our Model
        _ = try await persistenceService.delete(
            model: model,
            deleteModelOnDisk: false
        )

        // WHEN we select the Settings button
        testSubject.projectSettingsButton.onSelect()

        // THEN we have an alert that is nil
        var nextAlert = try #require(await alertIterator.next())
        #expect(nextAlert == nil)

        // THEN we have an alert about the LLM Prime failing
        nextAlert = try #require(await alertIterator.next())
        #expect(
            nextAlert == .init(
                title: "Failed to extract the necessary data out of the database",
                message: "Failed to find the necessary data in the database for this operation."
            )
        )
    }

    @Test("Ask Question - No Strict Mode")
    func enterSelectedNoStrictMode() async throws {
        // Ensure that our GPT responds with "Hello, World!"
        let expectedResponse = "Hello, World!"
        mockGptService.responseResult = .success(expectedResponse)

        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(
            id: 1,
            projectID: 1,
            modelID: 1,
            strictMode: false
        )
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)
        testSubject.configureBindingsIfNeeded()

        var sourcesIterator = testSubject.$sources.values.makeAsyncIterator()
        var responseIterator = testSubject.$response.values.makeAsyncIterator()
        var expectingResponseIterator = testSubject.$expectingResponse
            .values
            .makeAsyncIterator()

        // WHEN the enter question is entered
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the response is set to loading
        var nextResponse = try #require(await responseIterator.next())
        #expect(nextResponse.isLoading == true)

        // THEN we're set to expecting a response
        var nextExpectingResponse = await expectingResponseIterator.next()
        #expect(nextExpectingResponse == true)

        var nextSources = try #require(await sourcesIterator.next())

        // THEN the first Sources is `nil`
        #expect(nextSources == nil)

        // THEN the next Sources is not `nil`
        nextSources = try #require(await sourcesIterator.next())

        // THEN the next Sources is set correct
        #expect(nextSources?.id == 1)
        #expect(
            nextSources?.sources == [
                .init(document: Self.testDocuments[0], score: 0.7719761)
            ]
        )

        // Iterate over every single character, as we should receive each one
        // consecutively
        var responseSoFar = ""
        for char in expectedResponse {
            // THEN the response is "H", then "e", "l", etc
            nextResponse = try #require(await responseIterator.next())
            responseSoFar += String(char)

            #expect(nextResponse.isResponse(with: responseSoFar))
        }

        // THEN our response is "Hello, World!"
        #expect(nextResponse.isResponse(with: expectedResponse))

        // THEN `expectingResponse` is false
        nextExpectingResponse = await expectingResponseIterator.next()
        #expect(nextExpectingResponse == false)
    }

    @Test("Ask Question - Strict Mode")
    func enterSelectedStrictMode() async throws {
        // GIVEN we have a ProjectViewModel
        let settings = ProjectSettings.mock(
            id: 1,
            projectID: 1,
            modelID: 1,
            strictMode: true
        )
        let model = LLMModel.mock(id: 1)
        let testSubject = try await self.mock(true, model, settings)

        var sourcesIterator = testSubject.$sources
            .values
            .makeAsyncIterator()
        var responseIterator = testSubject.$response
            .values
            .makeAsyncIterator()
        var expectingResponseIterator = testSubject.$expectingResponse
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // WHEN the enter question is entered
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the response is set to loading
        var nextResponse = try #require(await responseIterator.next())
        #expect(nextResponse.isLoading == true)

        // THEN we're set to expect a response
        var nextExpectingResponse = await expectingResponseIterator.next()
        #expect(nextExpectingResponse == true)

        // THEN the first Sources is `nil`
        var nextSources = try #require(await sourcesIterator.next())
        #expect(nextSources == nil)

        // THEN the next Sources is not `nil`
        nextSources = try #require(await sourcesIterator.next())

        // THEN the next Sources is set correct
        #expect(nextSources?.id == 1)
        #expect(
            nextSources?.sources == [
                .init(document: Self.testDocuments[0], score: 0.7719761)
            ]
        )

        // THEN our response is appropriately set
        nextResponse = try #require(await responseIterator.next())
        #expect(nextResponse.isResponse(with: self.expectedStrictResponse))

        // THEN `expectingResponse` is false
        nextExpectingResponse = await expectingResponseIterator.next()
        #expect(nextExpectingResponse == false)
    }

    @Test("Example Question Selected")
    func exampleQuestionSelected() {
        // GIVEN we have a ProjectViewModel
        let testSubject = ProjectViewModel(
            project: .mock(),
            serviceContainer: serviceContainer
        )

        // THEN the `chatText` is set to empty initially
        #expect(testSubject.chatText.isEmpty == true)

        // WHEN an example question is selected
        testSubject.exampleQuestionSelected("How now brown cow?")

        // THEN the `chatText` is updated appropriately
        #expect(testSubject.chatText == "How now brown cow?")
    }

    @Test("Directory Selected")
    func directorySelected() async throws {
        // Let's create an old stale directory to call our own
        let oldTestURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project1")

        // Let's create a new directory to call our own
        let newTestURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project2/")
        try FileManager.default.createDirectory(
            at: newTestURL,
            withIntermediateDirectories: true
        )

        // GIVEN we have a Project that has the old directory
        let project = Project.mock(
            id: 1,
            path: oldTestURL.path(),
            alertStatus: .none
        )

        // GIVEN a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // WHEN a URL is selected
        testSubject.directorySelected(newTestURL)

        // THEN we do not get an alert
        #expect(testSubject.alertConfiguration == nil)

        // WHEN we get our new Project
        let updatedProject: Project = await withCheckedContinuation { continuation in
            persistenceService.getProject(id: 1)
                .dropFirst()
                .sink { project in
                    continuation.resume(returning: project)
                }
                .store(in: &cancellables)
        }

        // THEN our Project Path is updated
        #expect(updatedProject.path == newTestURL.path())

        // THEN our Project Data is still set
        #expect(updatedProject.urlBookmarkData.isEmpty == false)

        // THEN our Project AlertStatus is updated accordingly
        #expect(updatedProject.alertStatus == .warning(warning: .directoryChanged))
    }

    @Test("No Directory Selected")
    func noDirectorySelected() async throws {
        // GIVEN a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Listen in the Alert publisher
        var alertIterator = testSubject.$alertConfiguration.values.makeAsyncIterator()

        // THEN our alert is `nil`
        var nextAlert = try #require(await alertIterator.next())
        #expect(nextAlert == nil)

        // WHEN we select a `nil` directory
        testSubject.directorySelected(nil)

        // THEN we get an alert
        nextAlert = try #require(await alertIterator.next())

        // THEN the alert has the correct values
        #expect(
            nextAlert == .init(
                title: "Failed to get folder access",
                message: "Please ensure that a project directory has been selected."
            )
        )
    }

    @Test("Invalid Directory Selected")
    func invalidDirectorySelected() async throws {
        // GIVEN a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Listen in the Alert publisher
        var alertIterator = testSubject.$alertConfiguration.values.makeAsyncIterator()

        // THEN our alert is `nil`
        var nextAlert = try #require(await alertIterator.next())
        #expect(nextAlert == nil)

        // WHEN an invalid URL is selected
        let testURL = URL(fileURLWithPath: "/foo/bar/foobar")
        testSubject.directorySelected(testURL)

        // THEN we get an alert
        nextAlert = try #require(await alertIterator.next())

        // THEN the alert has the correct values
        #expect(
            nextAlert == .init(
                title: "Failed to get folder access",
                message: "The file “foobar” couldn’t be opened because there is no such file."
            )
        )
    }

    @Test("Build Example Questions")
    func buildExampleQuestions() async throws {
        // These are the questions we'll be using for testing
        let questions = [
            "What is a dog?",
            "What is a cat?",
            "What is a fish?"
        ]

        // GIVEN we have a Project
        let project = Project.mock(
            exampleQuestions: questions
        )

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator to listen to the Questions publisher
        var questionsIterator = testSubject.$questions.values.makeAsyncIterator()
        let nextQuestions = await questionsIterator.next()

        // THEN the example questions from the Project are now in the ViewModel
        #expect(
            nextQuestions == questions.map {
                ProjectQuestionViewModel(content: $0) { _ in }
            }
        )
    }

    @Test(
        "Build Alert Status",
        arguments: Project.AlertStatus.allCases
    )
    func buildAlertStatus(with alertStatus: Project.AlertStatus) async throws {
        // GIVEN we have a Project
        let project = Project.mock(alertStatus: alertStatus)

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator to listen to the Questions publisher
        var alertStatusIterator = testSubject.$alertStatus.values.makeAsyncIterator()
        let nextAlertStatus = await alertStatusIterator.next()

        // THEN our AlertStatus from our Project is now in the ViewModel
        #expect(nextAlertStatus == alertStatus)
    }

    @Test(
        "Alert Status Color on Sync Button",
        arguments: Project.AlertStatus.allCases
    )
    func alertStatusColorOnSyncButton(with alertStatus: Project.AlertStatus) async throws {
        // GIVEN we have a Project
        let project = Project.mock(alertStatus: alertStatus)

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator to listen to the Questions publisher
        var syncButtonWarningStateIterator = testSubject.syncProjectButton.$warningState.values.makeAsyncIterator()
        let nextSyncButtonWarningState = await syncButtonWarningStateIterator.next()

        // THEN our Icon is updated accordingly
        switch alertStatus {
        case .none:
            #expect(nextSyncButtonWarningState == ToolbarButtonViewModel.WarningState.none)
        case .warning:
            #expect(nextSyncButtonWarningState == .warning)
        case .error:
            #expect(nextSyncButtonWarningState == .error)
        }
    }

    @Test(
        "Alert Status Icon on Sync Button",
        arguments: Project.AlertStatus.allCases
    )
    func alertStatusIconOnSyncButton(with alertStatus: Project.AlertStatus) async throws {
        // GIVEN we have a Project
        let project = Project.mock(alertStatus: alertStatus)

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator to listen to the Questions publisher
        var syncButtonSymbolIterator = testSubject.syncProjectButton.$symbol.values.makeAsyncIterator()
        let nextSyncButtonSymbol = await syncButtonSymbolIterator.next()

        // THEN our Icon is updated accordingly
        switch alertStatus {
        case .none:
            #expect(nextSyncButtonSymbol == .arrowTriangle2Circlepath)
        default:
            #expect(nextSyncButtonSymbol == .exclamationmarkArrowTriangle2Circlepath)
        }
    }

    @Test("View Sources Button - Disabled - Syncing")
    func viewSourcesButtonDisabledSyncing() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()

        // Setup an iterator that listens to our SourcesButton isEnabled state
        var isEnabledIterator = testSubject.sourcesButton.$isEnabled
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // THEN our ViewSources button is disabled
        #expect(testSubject.sourcesButton.isEnabled == false)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the ViewSources button is at first NOT enabled
        var nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == false)

        // THEN the ViewSources button is then enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == true)

        // WHEN the sync button is selected
        testSubject.syncProjectButton.selected()

        // THEN our ViewSources is NOT enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == false)

        // THEN after our question is answered our ViewSources is back to enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == true)
    }

    @Test("View Sources Button - Disabled - No Sources")
    func viewSourcesButtonDisabledNoSources() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()

        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our SourcesButton isEnabled state
        var isEnabledIterator = testSubject.sourcesButton.$isEnabled
            .values
            .makeAsyncIterator()

        // THEN our ViewSources button is disabled
        #expect(testSubject.sourcesButton.isEnabled == false)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the ViewSources button is at first NOT enabled
        var nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == false)

        // THEN the ViewSources button is then enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == true)

        // WHEN the `sources` are removed
        testSubject.sources = nil

        // THEN the ViewSources is NOT enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == false)
    }

    @Test("View Sources Button - Enabled")
    func viewSourcesButtonEnabled() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()

        // Setup an iterator that listens to our SourcesButton isEnabled state
        var isEnabledIterator = testSubject.sourcesButton.$isEnabled
            .values
            .makeAsyncIterator()

        testSubject.configureBindingsIfNeeded()

        // THEN our ViewSources button is disabled
        #expect(testSubject.sourcesButton.isEnabled == false)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the ViewSources button is at first NOT enabled
        var nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == false)

        // THEN the ViewSources button is then enabled
        nextSourcesButtonEnabled = await isEnabledIterator.next()
        #expect(nextSourcesButtonEnabled == true)
    }

    @Test("Sync Button - Disabled - Syncing")
    func syncButtonDisabledWhenSyncing() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our SyncButton isEnabled state
        var isEnabledIterator = testSubject.syncProjectButton.$isEnabled
            .values
            .makeAsyncIterator()

        // THEN our SyncButton is enabled
        #expect(testSubject.syncProjectButton.isEnabled == true)

        // THEN the SyncButton is at first enabled
        var nextSyncButtonEnabled = await isEnabledIterator.next()
        #expect(nextSyncButtonEnabled == true)

        // WHEN the sync button is selected
        testSubject.syncProjectButton.selected()

        // THEN our SyncButton is NOT enabled
        nextSyncButtonEnabled = await isEnabledIterator.next()
        #expect(nextSyncButtonEnabled == false)

        // THEN after our sync, the SyncButton is enabled again
        nextSyncButtonEnabled = await isEnabledIterator.next()
        #expect(nextSyncButtonEnabled == true)
    }

    @Test("Settings Button - Disabled - Syncing")
    func settingsButtonDisabledWhenSyncing() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // THEN our SettingsButton is enabled
        #expect(testSubject.projectSettingsButton.isEnabled == true)

        // Setup an iterator that listens to our SettingsButton isEnabled state
        var isEnabledIterator = testSubject.projectSettingsButton.$isEnabled.values.makeAsyncIterator()

        // THEN the SettingsButton is at first enabled
        var nextSettingsButtonEnabled = await isEnabledIterator.next()
        #expect(nextSettingsButtonEnabled == true)

        // WHEN the SyncButton is selected
        testSubject.syncProjectButton.selected()

        // THEN our SettingsButton is NOT enabled
        nextSettingsButtonEnabled = await isEnabledIterator.next()
        #expect(nextSettingsButtonEnabled == false)

        // THEN after our sync, the SettingsButton is enabled again
        nextSettingsButtonEnabled = await isEnabledIterator.next()
        #expect(nextSettingsButtonEnabled == true)
    }

    @Test("Text View - Disabled - Expecting Response")
    func disableTextViewWhenExpectingResponse() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // THEN our TextView is NOT disabled
        #expect(testSubject.disableTextField == false)

        // Setup an iterator that listens to our TextView isEnabled state
        var isDisabledIterator = testSubject.$disableTextField.values.makeAsyncIterator()

        // THEN the TextView is at first NOT disabled
        var nextTextViewDisabled = await isDisabledIterator.next()
        #expect(nextTextViewDisabled == false)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN our TextView is disabled
        nextTextViewDisabled = await isDisabledIterator.next()
        #expect(nextTextViewDisabled == true)

        // THEN after our question is answered, the TextView is NOT disabled, again
        nextTextViewDisabled = await isDisabledIterator.next()
        #expect(nextTextViewDisabled == false)
    }

    @Test("Text View - Disabled - Error")
    func disableTextViewWhenError() async throws {
        // GIVEN we have a Project that has an error
        let project = Project.mock(alertStatus: .error(error: .firstSync))

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // THEN our TextView is disabled
        #expect(testSubject.disableTextField == true)
    }

    @Test("Text View - Enabled - Warning")
    func enableTextViewWhenError() async throws {
        // GIVEN we have a Project that has a warning
        let project = Project.mock(alertStatus: .warning(warning: .isDirty))

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // THEN our TextView is NOT disabled
        #expect(testSubject.disableTextField == false)
    }

    @Test("Ask Button - Title")
    func askButtonTitle() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our AskButton title
        var titleIterator = testSubject.$askButtonTitle.values.makeAsyncIterator()

        // THEN the AskButton title is "Ask"
        var nextTitle = await titleIterator.next()
        #expect(nextTitle == "Ask Question")

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the AskButton title is "Cancel"
        nextTitle = await titleIterator.next()
        #expect(nextTitle == "Cancel")

        // THEN once the response is provided, the AskButton title reverts back to "Ask"
        nextTitle = await titleIterator.next()
        #expect(nextTitle == "Ask Question")
    }

    @Test("Ask Button - Icon")
    func askButtonIcon() async throws {
        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our AskButton icon
        var iconIterator = testSubject.$askButtonIcon.values.makeAsyncIterator()

        // THEN the AskButton icon is "Ask"
        var nextIcon = await iconIterator.next()
        #expect(nextIcon == .playFill)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN the AskButton title is "Cancel"
        nextIcon = await iconIterator.next()
        #expect(nextIcon == .stopFill)

        // THEN once the response is provided, the AskButton title reverts back to "Ask"
        nextIcon = await iconIterator.next()
        #expect(nextIcon == .playFill)
    }

    @Test("Share Button - Disabled - Expecting Response")
    func shareButtonDisabledExpectingResponse() async throws {
        // Ensure that our GPT responds with "Hello, World!"
        let expectedResponse = "Hello, World!"
        mockGptService.responseResult = .success(expectedResponse)

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our TextView isEnabled state
        var isDisabledIterator = testSubject.$shareButtonDisabled.values.makeAsyncIterator()
        var nextShareButtonDisabled = await isDisabledIterator.next()

        // THEN the ShareButton is at first disabled
        #expect(nextShareButtonDisabled == true)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // THEN our ShareButton is NOT disabled
        nextShareButtonDisabled = await isDisabledIterator.next()
        #expect(nextShareButtonDisabled == false)
    }

    @Test("Response Feeds Into Share Content")
    func responseIsShareContent() async throws {
        // Ensure that our GPT responds with "Hello, World!"
        let expectedResponse = "Hello, World!"
        mockGptService.responseResult = .success(expectedResponse)

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock()
        testSubject.configureBindingsIfNeeded()

        // Setup an iterator that listens to our ShareContent values
        var shareContentIterator = testSubject.$shareContent.values.makeAsyncIterator()
        var nextShareContent = try #require(await shareContentIterator.next())

        // THEN the ShareContent is at first `nil`
        #expect(nextShareContent == nil)

        // WHEN a question is asked
        testSubject.chatText = "Give me some ways to improve my project with the ViewController?"
        testSubject.askButtonSelected()

        // Iterate over every single character, as we should receive each one
        // consecutively
        var responseSoFar = ""
        for char in expectedResponse {
            // THEN the response is "H", then "e", "l", etc
            nextShareContent = try #require(await shareContentIterator.next())
            responseSoFar += String(char)

            #expect(nextShareContent == responseSoFar)
        }

        // THEN our response is "Hello, World!"
        #expect(nextShareContent == expectedResponse)
    }

    @Test("Sync on Launch - First Sync")
    func syncOnLaunchFirstSync() async throws {
        // Let's create a new directory to call our own
        let testURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project2/")
        try FileManager.default.createDirectory(
            at: testURL,
            withIntermediateDirectories: true
        )

        // Add a test document to our project directory
        FileManager.default.createFile(
            atPath: testURL
                .appendingPathComponent("test1.txt", conformingTo: .text)
                .path(),
            contents: "Hello, World!".data(using: .utf8)
        )

        // Let's create BookmarkData to access it
        let bookmarkData = try testURL.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        // GIVEN we have a Project that is supposed to sync at first
        let project = Project.mock(
            id: 1,
            path: testURL.path(),
            urlBookmarkData: bookmarkData,
            alertStatus: .error(error: .firstSync)
        )

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Let's listen in on our SyncStage
        var syncStageIterator = testSubject.$syncStage.values.makeAsyncIterator()

        // THEN our next SyncStage is `extractingDocumentsFromDisk`
        var nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage == .extractingDocumentsFromDisk)

        // THEN our next SyncStage is `trainingDocuments`
        nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage?.isTrainingDocuments == true)

        // THEN our next SyncStage is `buildingExampleQuestions`
        nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage?.isBuildingExampleQuestions == true)
    }

    @Test("No Sync on Launch")
    func noSyncOnLaunch() async throws {
        // Let's create a new directory to call our own
        let testURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project2/")
        try FileManager.default.createDirectory(
            at: testURL,
            withIntermediateDirectories: true
        )

        // Add a test document to our project directory
        FileManager.default.createFile(
            atPath: testURL
                .appendingPathComponent("test1.txt", conformingTo: .text)
                .path(),
            contents: "Hello, World!".data(using: .utf8)
        )

        // Let's create BookmarkData to access it
        let bookmarkData = try testURL.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        // GIVEN we have a Project that is supposed to sync at first
        let project = Project.mock(
            id: 1,
            path: testURL.path(),
            urlBookmarkData: bookmarkData,
            alertStatus: .none
        )

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Let's listen in on our SyncStage
        var syncStageIterator = testSubject.$syncStage.values.makeAsyncIterator()

        // THEN our next SyncStage is `nil`
        let nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage == nil)

        // WHEN we wait a hot couple of seconds
        try await Task.sleep(for: .seconds(5))

        // THEN we are still `nil` and not syncing
        #expect(testSubject.syncStage == nil)
    }

    @Test("Sync - Sync Button")
    func syncFromSyncButton() async throws {
        // Let's create a new directory to call our own
        let testURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project2/")
        try FileManager.default.createDirectory(
            at: testURL,
            withIntermediateDirectories: true
        )

        // Add a test document to our project directory
        FileManager.default.createFile(
            atPath: testURL
                .appendingPathComponent("test1.txt", conformingTo: .text)
                .path(),
            contents: "Hello, World!".data(using: .utf8)
        )

        // Let's create BookmarkData to access it
        let bookmarkData = try testURL.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        // GIVEN we have a Project that is supposed to sync at first
        let project = Project.mock(
            id: 1,
            path: testURL.path(),
            urlBookmarkData: bookmarkData,
            alertStatus: .none
        )

        // GIVEN we have a ProjectViewModel
        let testSubject = try await self.mock(project)
        testSubject.configureBindingsIfNeeded()

        // Let's listen in on our SyncStage
        var syncStageIterator = testSubject.$syncStage.values.makeAsyncIterator()

        // THEN our next SyncStage is `nil`
        var nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage == nil)

        // WHEN we wait a hot couple of seconds
        try await Task.sleep(for: .seconds(5))

        // THEN we are still `nil` and not syncing
        #expect(testSubject.syncStage == nil)

        // WHEN we select the sync button
        testSubject.syncProjectButton.selected()

        // THEN our next SyncStage is `extractingDocumentsFromDisk`
        nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage == .extractingDocumentsFromDisk)

        // THEN our next SyncStage is `trainingDocuments`
        nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage?.isTrainingDocuments == true)

        // THEN our next SyncStage is `buildingExampleQuestions`
        nextSyncStage = try #require(await syncStageIterator.next())
        #expect(nextSyncStage?.isBuildingExampleQuestions == true)

    }

}

// MARK: - Private

private extension ProjectViewModelTests {

    var expectedStrictResponse: String {
        // swiftlint:disable:next line_length
        "Here\'s some excerpts from your documentation based on your query.\n\n# file.md\n\nTest Documentation: ViewController\n\nOverview\n\nPurpose\nThis document outlines the test coverage for ViewController. The ViewController is responsible for rendering the main UI and handling user interactions. The tests will verify:\n\t1.\tUI rendering\n\t2.\tUser input handling\n\t3.\tData flow between the ViewController and its ViewModel (or other dependencies)\n\t4.\tBehaviour under edge cases and errors\n\nTest Environment\n\nRequirements\n\t•\tXcode: Version 15 or later\n\t•\tSwift: 5.10 / 6\n\t•\tTesting Framework: SwiftTesting (or XCTest if applicable)\n\t•\tDependencies: Mocking framework (e.g., Mockingbird, MockitoSwift)\n\t•\tDevice/Simulator: iPhone 14 running iOS 17\n\nTest Cases\n\t1.\tUI Rendering\n\nTest ID: TC-001\nTest Case: Verify ViewController loads the UI\nSteps:\n\t1.\tLaunch the app. Open the target screen.\n\t2.\tCheck labels, buttons, and table views.\nExpected Result: All UI elements are visible.\n\nTest ID: TC-002\nTest Case: Verify\n\n"
    }

    func mock(
        _ overwriteProjectDirectory: Bool = true,
        _ model: LLMModel = .mock(id: 1),
        _ settings: ProjectSettings = .mock(projectID: 1, modelID: 1)
    ) async throws -> ProjectViewModel {
        let project = try Self.createProject(
            overwriteProjectDirectory: overwriteProjectDirectory
        )
        return try await mock(project, model, settings)
    }

    func mock(
        _ project: Project,
        _ model: LLMModel = .mock(id: 1),
        _ settings: ProjectSettings = .mock(projectID: 1, modelID: 1)
    ) async throws -> ProjectViewModel {

        // Persist the Project, Settings, and Model into the DB
        _ = try await persistenceService.insert(model: model)
        let insertedProject = try await persistenceService.insert(
            project: project
        )
        _ = try await persistenceService.insert(settings: settings)

        _ = try await persistenceService.insert(documents: Self.testDocuments)

        self.project = insertedProject
        return ProjectViewModel(
            project: insertedProject,
            serviceContainer: serviceContainer
        )
    }

    static func createProject(
        overwriteProjectDirectory: Bool = true
    ) throws -> Project {
        var project = Project.mock(id: 1, alertStatus: .warning(warning: .isDirty))

        // If we're supposed to create a real directory for this project, do
        // so and then persist the data
        if overwriteProjectDirectory {
            let testURLDir = try self.testProjectDirectory()
            project.path = testURLDir.path()
            project.urlBookmarkData = try testURLDir.bookmarkData(
                options: .securityScopeAllowOnlyReadAccess,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
        }

        return project
    }

    static func testProjectDirectory() throws -> URL {
        // Let's create a directory to call our own
        let testURLDir = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-project")
        try FileManager.default.createDirectory(
            at: testURLDir,
            withIntermediateDirectories: true
        )

        // Write in a file and persist it in the directory
        let fileURL = testURLDir
            .appendingPathComponent("test-document.txt")
        try "HelloWorld"
            .write(to: fileURL, atomically: true, encoding: .utf8)

        return testURLDir
    }

    static var testDocuments: [Document] {
        [
            .mock(
                id: 1,
                projectID: 1,
                embeddings: Document.Embedding.mock
            )
        ]
    }

    func errorMessage(for error: GPTError) -> String {
        switch error {
        case .llmNotInitialised:
            return "LLM Instance is not initialised."
        case .failedToCreateLLM(let reason):
            return "Failed to create LLM. \(reason)."
        case .noModel(let modelName):
            return "Failed to find the selected model, \(modelName)."
        case .failedToCreateLLMDecodingError:
            return "Failed to create LLM due to a decoding error."
        }
    }

}

// MARK: - ProjectViewModel.ResponseStatus

private extension ProjectViewModel.ResponseStatus {

    var isNone: Bool {
        guard case .none = self else {
            return false
        }
        return true
    }

    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }
        return true
    }

    var responseValue: String {
        get throws {
            guard case .response(let response) = self else {
                throw PersistenceError.valueNotFound
            }
            return response
        }
    }

    func isResponse(with value: String) -> Bool {
        guard case .response(let response) = self else {
            return false
        }

        return response == value
    }

}

// MARK: - ProjectViewModel.SyncStage

private extension ProjectViewModel.SyncStage {

    var isExtractingDocumentsFromDisk: Bool {
        guard case .extractingDocumentsFromDisk = self else {
            return false
        }
        return true
    }

    var isTrainingDocuments: Bool {
        guard case .trainingDocuments = self else {
            return false
        }
        return true
    }

    var isBuildingExampleQuestions: Bool {
        guard case .buildingExampleQuestions = self else {
            return false
        }
        return true
    }

}

// MARK: - GPTError.CaseIterable

extension GPTError: @retroactive CaseIterable {

    /// Provides a list of all possible `GPTError` cases.
    ///
    /// This is primarily useful for testing and enumerating all error types.
    public static var allCases: [GPTError] {
        [
            .noModel(modelName: "Test Model"),
            .failedToCreateLLMDecodingError,
            .failedToCreateLLM(reason: "Test Reason"),
            .llmNotInitialised
        ]
    }
}

// MARK: - Project.AlertStatus.CaseIterable

extension Project.AlertStatus: @retroactive CaseIterable {

    public static var allCases: [Project.AlertStatus] {
        let allWarning = Project.AlertStatus.WarningState.allCases.map {
            Project.AlertStatus.warning(warning: $0)
        }
        let allError = Project.AlertStatus.ErrorState.allCases.map {
            Project.AlertStatus.error(error: $0)
        }

        return [Project.AlertStatus.none] + allWarning + allError
    }

}  // swiftlint:disable:this file_length
