//
//  AlertConfiguration.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/10/2024.
//

public struct AlertConfiguration {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    public struct ActionConfiguration {
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

extension AlertConfiguration: Identifiable {

    public var id: String {
        self.title + self.message
    }

}
