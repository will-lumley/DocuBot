//
//  PreferenceStoreService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation

/// A protocol that defines the requirements for managing user preferences.
///
/// Conforming types are responsible for storing and retrieving user-specific settings, providing
/// a centralised interface for preference management.
public protocol PreferenceStoreService: Service {

    /// A Boolean value indicating whether the app has been launched previously.
    ///
    /// This property tracks the user's first launch experience.
    var launchedPreviously: Bool { get set }

    /// The number of example questions displayed to the user.
    ///
    /// This property defines how many example questions are shown in the app.
    var numberOfExampleQuestions: Int { get set }

    /// A Boolean value indicating whether similarity scoring is displayed.
    ///
    /// This property determines whether similarity scoring is visible in the app's interface.
    var displaySimilarityScoring: Bool { get set }

    /// The number of characters considered for prefix matching in document processing.
    ///
    /// This property controls the length of the prefix used for similarity calculations.
    var documentPrefixCount: Int { get set }

    /// The minimum similarity score required to consider a match valid.
    ///
    /// This property sets the threshold for similarity scoring in the app.
    var similarityFloorScore: Double { get set }

}
