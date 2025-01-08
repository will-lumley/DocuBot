//
//  SettingsViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

@Suite("SettingsViewModelTests", .tags(.view))
class SettingsViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("General Section")
    func generalSection() {
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)

        #expect(testSubject.generalSectionTitle == "General")
        #expect(testSubject.generalSectionIcon == .gear)
        #expect(testSubject.numberOfExampleQuestionsTitle == "Number of Example Questions")
        #expect(testSubject.displaySimilarityScoringTitle == "Display Similarity Score")
        #expect(testSubject.documentPrefixCountTitle == "Document Prefix Count")
        #expect(testSubject.similarityFloorScoreTitle == "Similarity Floor Score")
    }

    @Test("Embedding Section")
    func embeddingSection() {
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)

        #expect(testSubject.embeddingSectionTitle == "Embedding")
        #expect(testSubject.embeddingSectionIcon == .docViewfinder)
        #expect(testSubject.documentEmbeddingSectionTitle == "Embedding")
    }

    @Test("Setting - Number of Example Questions")
    func settingNumberOfExampleQuestions() {
        // GIVEN we have our SettingsViewModel
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)
        testSubject.configureBindingsIfNeeded()

        // WHEN we set a NumberOfExampleQuestions
        testSubject.numberOfExampleQuestions = 42

        // THEN the value exists in our PreferenceStore
        let newValue = serviceContainer.preferenceStoreService.numberOfExampleQuestions
        #expect(newValue == 42)
    }

    @Test("Setting - Display Similarity Scoring")
    func settingDisplaySimilarityScoring() {
        // GIVEN we have our SettingsViewModel
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)
        testSubject.configureBindingsIfNeeded()

        // WHEN we set a DisplaySimilarityScoring
        testSubject.displaySimilarityScoring = true

        // THEN the value exists in our PreferenceStore
        let newValue = serviceContainer.preferenceStoreService.displaySimilarityScoring
        #expect(newValue == true)
    }

    @Test("Setting - Document Prefix Count")
    func settingDocumentPrefixCount() {
        // GIVEN we have our SettingsViewModel
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)
        testSubject.configureBindingsIfNeeded()

        // WHEN we set a DocumentPrefixCount
        testSubject.documentPrefixCount = 68

        // THEN the value exists in our PreferenceStore
        let newValue = serviceContainer.preferenceStoreService.documentPrefixCount
        #expect(newValue == 68)
    }

    @Test("Setting - Similarity Floor Score")
    func settingSimilarityFloorScore() {
        // GIVEN we have our SettingsViewModel
        let testSubject = SettingsViewModel(serviceContainer: serviceContainer)
        testSubject.configureBindingsIfNeeded()

        // WHEN we set a NumberOfExampleQuestions
        testSubject.similarityFloorScore = 65

        // THEN the value exists in our PreferenceStore
        let newValue = serviceContainer.preferenceStoreService.similarityFloorScore
        #expect(newValue == 65)
    }

}
