//
//  HelpViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 15/10/2024.
//

public struct HelpConfiguration {

    // MARK: - Types

    public typealias OnDismiss = () -> Void

    // MARK: - Properties

    public let title: String
    public let content: String
    public let onDismiss: OnDismiss

    // MARK: - Lifecycle

    public init(title: String, content: String, onDismiss: @escaping OnDismiss) {
        self.title = title
        self.content = content
        self.onDismiss = onDismiss
    }

}

// MARK: - Public

public extension HelpConfiguration {

    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill) {
            self.onDismiss()
        }
    }

}

// MARK: - Hashable

extension HelpConfiguration: Hashable {

    public static func == (
        lhs: HelpConfiguration,
        rhs: HelpConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(content)
    }

}

// MARK: - Identifiable

extension HelpConfiguration: Identifiable {

    public var id: String {
        self.title + self.content
    }

}
