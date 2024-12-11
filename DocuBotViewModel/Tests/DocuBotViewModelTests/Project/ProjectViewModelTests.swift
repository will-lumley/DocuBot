//
//  ProjectViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 10/12/2024.
//

import DocuBotModel
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
    func llmIsPrimed() {
        // GIVEN we have a ProjectViewModel
        let testSubject = ProjectViewModel(
            project: .mock(),
            serviceContainer: serviceContainer
        )

        
    }

    @Test("Open Setttings")
    func openSettings() {
        
    }

    @Test("Enter Selected")
    func enterSelected() {
        
    }

    @Test("Example Question Selected")
    func exampleQuestionSelected() {
        
    }

    @Test("Directory Selected")
    func directorySelected() {
        
    }

    @Test("Ask Button Selected - Start")
    func startAskButtonSelected() {
        
    }

    @Test("Ask Button Selected - Stop")
    func stopAskButtonSelected() {
        
    }

    @Test("Build Example Questions")
    func buildExampleQuestions() {
        
    }

    @Test("Build Alert Status")
    func buildAlertStatus() {
        
    }

    @Test("Alert Status Icon on Sync Button")
    func alertStatusIconOnSyncButton() {
        
    }

    @Test("Alert Status Color on Sync Button")
    func alertStatusColorOnSyncButton() {
        
    }

    @Test("View Sources Button - Disabled - Syncing")
    func viewSourcesButtonDisabledSyncing() {
        
    }

    @Test("View Sources Button - Disabled - No Sources")
    func viewSourcesButtonDisabledNoSources() {
        
    }

    @Test("View Sources Button - Enabled")
    func viewSourcesButtonEnabledNoSources() {
        
    }

    @Test("Sync Button - Disabled - Syncing")
    func syncButtonDisabledWhenSyncing() {
        
    }

    @Test("Settings Button - Disabled - Syncing")
    func settingsButtonDisabledWhenSyncing() {
        
    }

    @Test("Text View - Disabled - Syncing")
    func disableTextViewWhenSyncing() {
        
    }

    @Test("Text View - Disabled - Error")
    func disableTextViewWhenError() {
        
    }

    @Test("Ask Button Title - Expecting Response")
    func askButtonTitleExpectingResponse() {
        
    }

    @Test("Ask Button Title - Not Expecting Response")
    func askButtonTitleNotExpectingResponse() {
        
    }

    @Test("Ask Button Icon - Expecting Response")
    func askButtonIconExpectingResponse() {
        
    }

    @Test("Ask Button Icon - Not Expecting Response")
    func askButtonIconNotExpectingResponse() {
        
    }

    @Test("Share Button - Disabled - No Share Content")
    func shareButtonDisabledNoShareContent() {
        
    }

    @Test("Share Button - Disabled - Expecting Response")
    func shareButtonDisabledExpectingResponse() {
        
    }

    @Test("Response Feeds Into Share Content")
    func responseIsShareContent() {
        
    }

}
