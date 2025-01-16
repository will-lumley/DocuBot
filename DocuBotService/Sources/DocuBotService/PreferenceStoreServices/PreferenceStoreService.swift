//
//  PreferenceStoreService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation

public protocol PreferenceStoreService: Service {
    var launchedPreviously: Bool { get set }
    var numberOfExampleQuestions: Int { get set }
    var displaySimilarityScoring: Bool { get set }
    var documentPrefixCount: Int { get set }
    var similarityFloorScore: Double { get set }
}
