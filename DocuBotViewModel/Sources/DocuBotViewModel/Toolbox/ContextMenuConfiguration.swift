//
//  ContextMenuConfiguration.swift
//
//
//  Created by William Lumley on 29/7/2024.
//

import Foundation

/// A configuration model for creating context menu items with associated actions.
public struct ContextMenuConfiguration {

    // MARK: - Types

    /// A closure typealias for the action to perform when a menu item is selected.
    public typealias OnSelect = () -> Void

    // MARK: - Properties

    /// The text to display for the context menu item.
    public let text: String

    /// The action to execute when the context menu item is selected.
    public let onSelect: OnSelect
}

// MARK: - Identifiable

extension ContextMenuConfiguration: Identifiable {

    /// A unique identifier for the context menu configuration, derived from its text.
    public var id: String {
        self.text
    }

}

// MARK: - Hashable

extension ContextMenuConfiguration: Hashable {

    /// Determines equality between two `ContextMenuConfiguration` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the text of both configurations is identical; otherwise, `false`.
    public static func == (lhs: ContextMenuConfiguration, rhs: ContextMenuConfiguration) -> Bool {
        return lhs.text == rhs.text
    }

    /// Hashes the `ContextMenuConfiguration` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.text)
    }

}
