//
//  ContextMenuConfiguration.swift
//
//
//  Created by William Lumley on 29/7/2024.
//

import Foundation

public struct ContextMenuConfiguration {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    // MARK: - Properties

    public let text: String
    public let onSelect: OnSelect

}

// MARK: - Identifiable

extension ContextMenuConfiguration: Identifiable {

    public var id: String {
        self.text
    }

}

// MARK: - Hashable

extension ContextMenuConfiguration: Hashable {

    public static func == (lhs: ContextMenuConfiguration, rhs: ContextMenuConfiguration) -> Bool {
        return lhs.text == rhs.text
    }
    

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.text)
    }

}
