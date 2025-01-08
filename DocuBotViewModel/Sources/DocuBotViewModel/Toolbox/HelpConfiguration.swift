//
//  HelpViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 15/10/2024.
//

/// A configuration model for providing help content within the application.
public struct HelpConfiguration {

    // MARK: - Types

    /// A closure typealias for the action to perform when the help view is dismissed.
    public typealias OnDismiss = () -> Void

    // MARK: - Properties

    /// The title of the help content.
    public let title: String

    /// The main content of the help view, typically displayed as a string.
    public let content: String

    /// The action to execute when the help view is dismissed.
    public let onDismiss: OnDismiss

    // MARK: - Lifecycle

    /// Initializes a new `HelpConfiguration`.
    ///
    /// - Parameters:
    ///   - title: The title of the help content.
    ///   - content: The main content of the help view.
    ///   - onDismiss: A closure to execute when the help view is dismissed.
    public init(title: String, content: String, onDismiss: @escaping OnDismiss) {
        self.title = title
        self.content = content
        self.onDismiss = onDismiss
    }

}

// MARK: - Public

public extension HelpConfiguration {

    /// The close button ViewModel for the help view.
    ///
    /// - Returns: An `IconButtonViewModel` configured to close the help view.
    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill) {
            self.onDismiss()
        }
    }

}

// MARK: - Hashable

extension HelpConfiguration: Hashable {

    /// Determines equality between two `HelpConfiguration` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two configurations have the same `id`, otherwise `false`.
    public static func == (
        lhs: HelpConfiguration,
        rhs: HelpConfiguration
    ) -> Bool {
        return lhs.id == rhs.id
    }

    /// Hashes the `HelpConfiguration` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(content)
    }

}

// MARK: - Identifiable

extension HelpConfiguration: Identifiable {

    /// A unique identifier for the help configuration, derived from its title and content.
    public var id: String {
        self.title + self.content
    }

}
