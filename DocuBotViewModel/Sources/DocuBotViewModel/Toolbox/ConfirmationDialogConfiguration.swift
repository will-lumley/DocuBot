//
//  ConfirmationDialogConfiguration.swift
//
//
//  Created by William Lumley on 13/8/2024.
//

import Combine
import Foundation

public struct ConfirmationDialogConfiguration {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    public struct ButtonConfiguration {

        public enum Role: String {
            case destructive
            case cancel
        }

        public let title: String
        public let role: Role
        public let action: OnSelect
    }

    // MARK: - Properties

    public let title: String
    public let buttons: [ButtonConfiguration]

}

// MARK: - Identifiable

extension ConfirmationDialogConfiguration: Identifiable {

    public var id: String {
        self.title
    }

}

// MARK: - ConfirmationDialogConfiguration.ButtonConfiguration

extension ConfirmationDialogConfiguration.ButtonConfiguration: Identifiable {

    public var id: String {
        self.title + self.role.rawValue
    }

}

extension ConfirmationDialogConfiguration.ButtonConfiguration: Equatable {

    public static func == (
        lhs: ConfirmationDialogConfiguration.ButtonConfiguration,
        rhs: ConfirmationDialogConfiguration.ButtonConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

}
