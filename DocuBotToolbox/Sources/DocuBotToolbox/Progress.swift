//
//  Progress.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 22/10/2024.
//

public struct Progress: Hashable, Sendable {

    // MARK: - Properties

    public let value: Double
    public let total: Double

    // MARK: - Lifecycle

    public init(value: Double, total: Double) {
        self.value = value
        self.total = total
    }

}

// MARK: - Public

public extension Progress {

    var percentage: Double {
        value / total * 100
    }

}
