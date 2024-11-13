//
//  MockPreferenceStoreService.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

public class MockPreferenceStoreService: PreferenceStoreService {

    // MARK: - Service

    public static var key: ServiceKey {
        .preferenceStore
    }

    // MARK: - Properties

    public var launchedPreviously: Bool
    public var numberOfExampleQuestions: Int
    public var displaySimilarityScoring: Bool
    public var documentPrefixCount: Int
    public var similarityFloorScore: Double

    // MARK: - Lifecycle

    init() {
        self.launchedPreviously = false
        self.numberOfExampleQuestions = 10
        self.displaySimilarityScoring = true
        self.documentPrefixCount = 3
        self.similarityFloorScore = 75
    }

}
