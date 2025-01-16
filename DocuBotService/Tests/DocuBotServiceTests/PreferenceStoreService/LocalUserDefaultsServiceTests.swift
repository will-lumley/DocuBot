//
//  LocalUserDefaultsServiceTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Testing

@Suite("LocalUserDefaultsServiceTests", .serialized)
struct LocalUserDefaultsServiceTests {

    @Test("Key Value")
    func keyValue() {
        #expect(LocalUserDefaultsService.key == .preferenceStore)
    }

    @Test("Launched Previously")
    func launchedPreviously() throws {
        let testSubject = LocalUserDefaultsService()

        testSubject.launchedPreviously = true
        #expect(testSubject.launchedPreviously == true)

        testSubject.launchedPreviously = false
        #expect(testSubject.launchedPreviously == false)
    }

    @Test("Number of Example Questions")
    func numberOfExampleQuestions() throws {
        let testSubject = LocalUserDefaultsService()

        testSubject.numberOfExampleQuestions = 10
        #expect(testSubject.numberOfExampleQuestions == 10)

        testSubject.numberOfExampleQuestions = 5
        #expect(testSubject.numberOfExampleQuestions == 5)
    }

    @Test("Display Similarity Scoring")
    func displaySimilarityScoring() throws {
        let testSubject = LocalUserDefaultsService()

        testSubject.displaySimilarityScoring = true
        #expect(testSubject.displaySimilarityScoring == true)

        testSubject.displaySimilarityScoring = false
        #expect(testSubject.displaySimilarityScoring == false)
    }

    @Test("Document Prefix Count")
    func documentPrefixCount() throws {
        let testSubject = LocalUserDefaultsService()

        testSubject.documentPrefixCount = 10
        #expect(testSubject.documentPrefixCount == 10)

        testSubject.documentPrefixCount = 5
        #expect(testSubject.documentPrefixCount == 5)
    }

    @Test("Similarity Floor Score")
    func similarityFloorScore() throws {
        let testSubject = LocalUserDefaultsService()

        testSubject.similarityFloorScore = 10
        #expect(testSubject.similarityFloorScore == 10)

        testSubject.similarityFloorScore = 5
        #expect(testSubject.similarityFloorScore == 5)
    }

}
