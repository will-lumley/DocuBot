//
//  ServiceFlags.swift
//  
//
//  Created by William Lumley on 13/7/2023.
//

import Vexil

public struct ServiceFlags: FlagContainer {

    // MARK: - Types

    public enum LogService: String, CaseIterable, FlagValue {
        case empty
        case print
    }

    // MARK: - Flags

    @Flag(default: LogService.empty, description: "The Log service that we will use")
    public var logService: LogService

    // MARK: - Lifecycle

    public init() {
        // Intentionally left blank
    }
}
