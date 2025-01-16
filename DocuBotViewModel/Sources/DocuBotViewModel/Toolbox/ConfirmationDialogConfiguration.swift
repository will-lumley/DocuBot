//
//  ConfirmationDialogConfiguration.swift
//
//
//  Created by William Lumley on 13/8/2024.
//

import Combine
import Foundation

/// A configuration model for creating confirmation dialogs with multiple buttons and associated actions.
public struct ConfirmationDialogConfiguration {

    // MARK: - Types

    /// A closure typealias for the action to perform when a button is selected.
    public typealias OnSelect = () async -> Void

    /// Represents a button configuration within a confirmation dialog.
    public struct ButtonConfiguration {

        /// The role of the button, indicating its purpose within the dialog.
        public enum Role: String {
            /// A button that performs a destructive action.
            case destructive
            /// A button that cancels the dialog.
            case cancel
        }

        /// The title of the button.
        public let title: String

        /// The role of the button, indicating its purpose (e.g., cancel, destructive).
        public let role: Role

        /// The action to execute when the button is selected.
        public let action: OnSelect

        /// Initializes a new `ButtonConfiguration`.
        ///
        /// - Parameters:
        ///   - title: The title of the button.
        ///   - role: The role of the button, indicating its purpose.
        ///   - action: A closure to execute when the button is selected.
        public init(title: String, role: Role, action: @escaping OnSelect) {
            self.title = title
            self.role = role
            self.action = action
        }
    }

    // MARK: - Properties

    /// The title of the confirmation dialog.
    public let title: String

    /// The buttons to display in the confirmation dialog.
    public let buttons: [ButtonConfiguration]

    /// Initializes a new `ConfirmationDialogConfiguration`.
    ///
    /// - Parameters:
    ///   - title: The title of the confirmation dialog.
    ///   - buttons: The buttons to display in the confirmation dialog.
    public init(title: String, buttons: [ButtonConfiguration]) {
        self.title = title
        self.buttons = buttons
    }
}

// MARK: - Identifiable

extension ConfirmationDialogConfiguration: Identifiable {

    /// A unique identifier for the confirmation dialog, derived from its title.
    public var id: String {
        self.title
    }

}

// MARK: - ButtonConfiguration Extensions

extension ConfirmationDialogConfiguration.ButtonConfiguration: Identifiable {

    /// A unique identifier for the button, derived from its title and role.
    public var id: String {
        self.title + self.role.rawValue
    }

}

extension ConfirmationDialogConfiguration.ButtonConfiguration: Equatable {

    /// Determines equality between two `ButtonConfiguration` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two button configurations have the same `id`; otherwise, `false`.
    public static func == (
        lhs: ConfirmationDialogConfiguration.ButtonConfiguration,
        rhs: ConfirmationDialogConfiguration.ButtonConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

}
