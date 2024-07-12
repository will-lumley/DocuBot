//
//  AppFlags.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation
import Vexil

public struct AppFlags: FlagContainer {

    // MARK: - Flags

    @FlagGroup(description: "Flags controlling which services will be leveraged")
    public var services: ServiceFlags

    // MARK: - Lifecycle

    public init() {
        // Intentionally left blank
    }

}
