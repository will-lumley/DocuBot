//
//  AlertConfiguration.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/10/2024.
//

/// A configuration model for creating and managing alerts in the application.
public struct AlertConfiguration: Sendable {

    // MARK: - Types

    /// A closure typealias for the action to perform when an alert action is selected.
    public typealias OnSelect = () -> Void

    /// Represents a configuration for an action in the alert.
    public struct ActionConfiguration: @unchecked Sendable {

        /// The title of the action.
        public let title: String

        /// The action to execute when the button is selected.
        public let onSelect: OnSelect

        /// Initializes a new `ActionConfiguration`.
        ///
        /// - Parameters:
        ///   - title: The title of the action.
        ///   - onSelect: A closure to execute when the action is selected.
        public init(title: String, onSelect: @escaping OnSelect) {
            self.title = title
            self.onSelect = onSelect
        }
    }

    // MARK: - Properties

    /// The title of the alert.
    public let title: String

    /// The message displayed in the alert.
    public let message: String

    /// An optional primary action associated with the alert.
    public let primaryAction: ActionConfiguration?

    /// Initializes a new `AlertConfiguration`.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message displayed in the alert.
    ///   - primaryAction: An optional primary action associated with the alert. Defaults to `nil`.
    public init(
        title: String,
        message: String,
        primaryAction: ActionConfiguration? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
    }

}

// MARK: - Identifiable

extension AlertConfiguration: Identifiable {

    /// A unique identifier for the alert configuration, derived from its title, message, and primary action.
    public var id: String {
        if let primaryAction {
            return self.title + self.message + primaryAction.title
        } else {
            return self.title + self.message
        }
    }

}

// MARK: - Equatable

extension AlertConfiguration: Hashable {

    /// Determines equality between two `AlertConfiguration` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two configurations have the same `id`; otherwise, `false`.
    public static func == (
        lhs: AlertConfiguration,
        rhs: AlertConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

    /// Hashes the `AlertConfiguration` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(message)
        hasher.combine(primaryAction)
    }

}

// MARK: - ActionConfiguration.Hashable

extension AlertConfiguration.ActionConfiguration: Hashable {

    /// Hashes the `ActionConfiguration` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    /// Determines equality between two `ActionConfiguration` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two configurations have the same title; otherwise, `false`.
    public static func == (
        lhs: AlertConfiguration.ActionConfiguration,
        rhs: AlertConfiguration.ActionConfiguration
    ) -> Bool {
        return lhs.title == rhs.title
    }

}
