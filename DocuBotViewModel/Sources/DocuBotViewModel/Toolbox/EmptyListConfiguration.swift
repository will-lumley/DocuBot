//
//  EmptyListConfiguration.swift
//
//
//  Created by William Lumley on 24/7/2024.
//

import Foundation
@preconcurrency import SFSafeSymbols

/// A configuration model for managing the appearance and behaviour of an empty list view.
public struct EmptyListConfiguration: Equatable, Sendable {

    // MARK: - Types

    /// A closure typealias for the action to perform when an action is selected.
    public typealias OnSelect = () -> Void

    /// Represents an action associated with the empty list configuration.
    public struct Action: @unchecked Sendable, Equatable {

        /// The primary title for the action.
        public let title: String

        /// An optional secondary title for the action.
        public let secondaryTitle: String?

        /// A closure to execute when the action is selected.
        public let onSelect: OnSelect

        /// Initializes a new `Action`.
        ///
        /// - Parameters:
        ///   - title: The primary title of the action.
        ///   - secondaryTitle: An optional secondary title for the action. Defaults to `nil`.
        ///   - onSelect: A closure to execute when the action is selected.
        public init(
            title: String,
            secondaryTitle: String? = nil,
            onSelect: @escaping OnSelect
        ) {
            self.title = title
            self.secondaryTitle = secondaryTitle
            self.onSelect = onSelect
        }

        /// Determines equality between two `Action` instances.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand instance.
        ///   - rhs: The right-hand instance.
        /// - Returns: `true` if the titles and secondary titles are equal; otherwise, `false`.
        public static func == (
            lhs: EmptyListConfiguration.Action,
            rhs: EmptyListConfiguration.Action
        ) -> Bool {
            return
                lhs.title == rhs.title &&
                lhs.secondaryTitle == rhs.secondaryTitle
        }
    }

    // MARK: - Properties

    /// The title to display in the empty list view.
    public let title: String

    /// The subtitle to display in the empty list view.
    public let subtitle: String

    /// The icon to display in the empty list view.
    public let icon: SFSymbol

    /// An optional action to display and execute in the empty list view.
    public let action: Action?

    // MARK: - Lifecycle

    /// Initializes a new `EmptyListConfiguration`.
    ///
    /// - Parameters:
    ///   - title: The title to display in the empty list view.
    ///   - subtitle: The subtitle to display in the empty list view.
    ///   - icon: The icon to display in the empty list view.
    ///   - action: An optional action associated with the empty list view. Defaults to `nil`.
    public init(
        title: String,
        subtitle: String,
        icon: SFSymbol,
        action: Action? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
    }
}
