//
//  IconButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

/// A ViewModel representing an icon button with configurable symbols, state, and action.
public final class IconButtonViewModel: ObservableObject {

    // MARK: - Types

    /// A closure typealias for the action to perform when the button is selected.
    public typealias OnSelect = () -> Void

    // MARK: - Properties

    /// The primary symbol (icon) displayed on the button.
    @Published public var symbol: SFSymbol

    /// An optional symbol (icon) displayed when the button is hovered over.
    @Published public var hoverSymbol: SFSymbol?

    /// A flag indicating whether the button is enabled.
    @Published public var isEnabled: Bool = true

    /// The action to execute when the button is selected.
    private let onSelect: OnSelect

    // MARK: - Lifecycle

    /// Initializes a new `IconButtonViewModel`.
    ///
    /// - Parameters:
    ///   - symbol: The primary symbol (icon) for the button.
    ///   - hoverSymbol: An optional symbol to display when the button is hovered over. Defaults to `nil`.
    ///   - onSelect: A closure to execute when the button is selected. Defaults to an empty closure.
    public init(
        symbol: SFSymbol,
        hoverSymbol: SFSymbol? = nil,
        onSelect: @escaping OnSelect = { }
    ) {
        self.symbol = symbol
        self.hoverSymbol = hoverSymbol
        self.onSelect = onSelect
    }

}

// MARK: - Public

public extension IconButtonViewModel {

    /// Executes the selection action associated with the icon button.
    func selected() {
        self.onSelect()
    }

}
