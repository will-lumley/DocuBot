//
//  ToolbarButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

/// A ViewModel representing a toolbar button with configurable state, behaviour, and appearance.
public final class ToolbarButtonViewModel: ObservableObject {

    // MARK: - Types

    /// Represents the warning state of the toolbar button.
    public enum WarningState {
        /// No warnings are present.
        case none
        /// A warning is present.
        case warning
        /// An error is present.
        case error
    }

    /// A closure typealias for the action to perform when the button is selected.
    public typealias OnSelect = () -> Void

    // MARK: - Properties

    /// The name of the toolbar button, typically used for display purposes.
    @Published public var name: String

    /// The symbol (icon) representing the button.
    @Published public var symbol: SFSymbol

    /// The symbol to display when the button is hovered over. Optional.
    @Published public var hoverSymbol: SFSymbol?

    /// A flag indicating whether the button is enabled.
    @Published public var isEnabled: Bool = true

    /// The current warning state of the button.
    @Published public var warningState: WarningState = .none

    /// A closure to execute when the button is selected.
    public var onSelect: OnSelect

    // MARK: - Lifecycle

    /// Initializes a new `ToolbarButtonViewModel`.
    ///
    /// - Parameters:
    ///   - name: The name of the button.
    ///   - symbol: The primary symbol (icon) for the button.
    ///   - isEnabled: A flag indicating if the button is enabled. Defaults to `true`.
    ///   - warningState: The initial warning state of the button. Defaults to `.none`.
    ///   - onSelect: A closure to execute when the button is selected. Defaults to an empty closure.
    public init(
        name: String,
        symbol: SFSymbol,
        isEnabled: Bool = true,
        warningState: WarningState = .none,
        onSelect: @escaping OnSelect = { }
    ) {
        self.name = name
        self.symbol = symbol
        self.isEnabled = isEnabled
        self.onSelect = onSelect
    }

}

// MARK: - Public

public extension ToolbarButtonViewModel {

    /// Executes the selection action associated with the button.
    func selected() {
        self.onSelect()
    }

}

// MARK: - Equatable

extension ToolbarButtonViewModel: Equatable {

    /// Determines equality between two `ToolbarButtonViewModel` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if all relevant properties of the two instances are equal; otherwise, `false`.
    public static func == (
        lhs: ToolbarButtonViewModel,
        rhs: ToolbarButtonViewModel
    ) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.symbol == rhs.symbol &&
            lhs.hoverSymbol == rhs.hoverSymbol &&
            lhs.isEnabled == rhs.isEnabled &&
            lhs.warningState == rhs.warningState
    }

}
