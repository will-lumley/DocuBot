//
//  HelpConfiguration+SettingsViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

// swiftlint:disable line_length

@Suite("HelpConfigurationSettingsViewModelTests", .tags(.view))
class HelpConfigurationSettingsViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test(
        "Help Button Selected",
        arguments: SettingsViewModel.HelpType.allCases
    )
    func helpButtonEmbeddedSelected(
        type: SettingsViewModel.HelpType
    ) async throws {
        // GIVEN a SettingsViewModel
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)

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

}

// MARK: - Private

private extension HelpConfigurationSettingsViewModelTests {

    func helpConfigurationTitle(
        for type: SettingsViewModel.HelpType
    ) -> String {
        switch type {
        case .numberOfExampleQuestions:
            return "Number of Example Questions"
        case .displaySimilarityScoring:
            return "Display Similarity Score"
        case .documentPrefixCount:
            return "Document Prefix Count"
        case .similarityFloorScore:
            return "Similarity Floor Score"
        }
    }

    func helpConfigurationContent(
        for type: SettingsViewModel.HelpType
    ) -> String {
        switch type {
        case .numberOfExampleQuestions:
            return "This value determines how many examples questions will be created during a sync of a project.\n\nYou can set this value to 0 to disable example questions entirely."
        case .displaySimilarityScoring:
            return "Within the sources list that is available after a query is performed, you can opt in to have the similarity score for that document represented in a pie chart.\n\nThe similarity score represents how closely related DocuBot predicts your query is to each document. A higher score indicates a stronger match, helping you quickly identify the most relevant sources for your search."
        case .documentPrefixCount:
            return "This value represents how many document excerpts we'll attach to your query when interfacing with the LLM.\n\nA higher count will give DocuBot more insight into your project, but it can also overload the LLM with information and limit it's ability to provide a response."
        case .similarityFloorScore:
            return "This value represents the minimum similarity score a document has to achieve to your query to be included in the context given to the LLM."
        }
    }

}

// swiftlint:enable line_length
