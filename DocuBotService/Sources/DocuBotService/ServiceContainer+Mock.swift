//
//  ServiceContainer+Mock.swift
//
//
//  Created by William Lumley on 24/7/2023.
//

import Foundation

/// An extension on `ServiceContainer` to provide a mock instance for testing purposes.
public extension ServiceContainer {

    /// A mock instance of `ServiceContainer` configured for testing.
    ///
    /// This mock instance is created with `isTesting` set to `true`, allowing for tailored behaviour
    /// during unit tests or other test scenarios.
    ///
    /// - Returns: A `ServiceContainer` instance configured for testing.
    static var mock: ServiceContainer {
        ServiceContainer(isTesting: true)
    }

}
