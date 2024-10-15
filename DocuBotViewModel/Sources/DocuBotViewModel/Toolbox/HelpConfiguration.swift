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

}

// MARK: - Public

public extension HelpConfiguration {

    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill) {
            self.onDismiss()
        }
    }

}

// MARK: - Identifiable

extension HelpConfiguration: Identifiable {

    public var id: String {
        self.title + self.content
    }

}

// MARK: - Preview

public extension HelpConfiguration {

    static var mock: HelpConfiguration {
        .init(
            title: "This is a help title",
            content:
                """
                This is a help content string that is very long and will wrap to the next line.
                When it does wrap, it will be truncated to 100 characters. Then it will finish typing.
                """
        ) { }
    }

}
