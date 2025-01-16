//
//  Progress.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 22/10/2024.
//

public struct Progress: Hashable, Sendable {

    public let value: Double
    public let total: Double

    public var percentage: Double {
        value / total * 100
    }

    public init(value: Double, total: Double) {
        self.value = value
        self.total = total
    }

}
