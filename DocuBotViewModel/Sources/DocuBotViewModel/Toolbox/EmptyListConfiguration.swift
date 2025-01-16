//
//  EmptyListConfiguration.swift
//
//
//  Created by William Lumley on 24/7/2024.
//

import Foundation
import SFSafeSymbols

public struct EmptyListConfiguration {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    public struct Action {
        public let title: String
        public let secondaryTitle: String?
        public let onSelect: OnSelect

        init(
            title: String,
            secondaryTitle: String? = nil,
            onSelect: @escaping OnSelect
        ) {
            self.title = title
            self.secondaryTitle = secondaryTitle
            self.onSelect = onSelect
        }
    }

    // MARK: - Properties

    public let title: String
    public let subtitle: String
    public let icon: SFSymbol
    public let action: Action?

    // MARK: - Lifecycle

    init(
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

// MARK: - Preview

public extension EmptyListConfiguration {

    static var mock: EmptyListConfiguration {
        .init(
            title: "Empty Title Empty",
            subtitle: "Empty Subtitle Empty Subtitle",
            icon: .booksVerticalFill,
            action: .init(title: "Click me", onSelect: {})
        )
    }

}
