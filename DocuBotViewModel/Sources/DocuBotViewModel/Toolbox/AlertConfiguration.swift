//
//  AlertConfiguration.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/10/2024.
//

public struct AlertConfiguration: Sendable {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    public struct ActionConfiguration: @unchecked Sendable {
        public let title: String
        public let onSelect: OnSelect
    }

    // MARK: - Properties

    public let title: String
    public let message: String
    public let primaryAction: ActionConfiguration?

    init(title: String, message: String, primaryAction: ActionConfiguration? = nil) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
    }

}

// MARK: - Identifiable

extension AlertConfiguration: Identifiable {

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

    public static func == (
        lhs: AlertConfiguration,
        rhs: AlertConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(message)
        hasher.combine(primaryAction)
    }

}

// MARK: - ActionConfiguration.Hashable

extension AlertConfiguration.ActionConfiguration: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    public static func == (
        lhs: AlertConfiguration.ActionConfiguration,
        rhs: AlertConfiguration.ActionConfiguration
    ) -> Bool {
        return lhs.title == rhs.title
    }

}
