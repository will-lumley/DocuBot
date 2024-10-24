//
//  Progress.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 22/10/2024.
//

public struct Progress: Hashable, Sendable {
    public let value: Int
    public let total: Int

    public init(value: Int, total: Int) {
        self.value = value
        self.total = total
    }
}
