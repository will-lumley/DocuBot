//
//  FlagService.swift
//
//
//  Created by William Lumley on 1/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

/// A protocol defining the requirements for a feature flag management service.
///
/// The `FlagService` protocol provides access to feature flag values and configurations,
/// enabling dynamic control of application features and behaviour.
public protocol FlagService: Service {

    /// The source of the flag values.
    ///
    /// This property provides access to the underlying data source that supplies the feature flag values.
    var source: FlagValueSource { get }

    /// The `FlagPole` containing the application's feature flags.
    ///
    /// This property encapsulates the feature flags used throughout the application, allowing for
    /// easy access and management of dynamic behaviours.
    var appFlags: FlagPole<AppFlags> { get }

}
