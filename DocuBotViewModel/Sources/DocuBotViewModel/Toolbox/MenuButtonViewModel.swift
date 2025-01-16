//
//  MenuButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

/// A ViewModel representing a menu button with configurable text, state, and action.
public final class MenuButtonViewModel: ObservableObject {

    // MARK: - Types

    /// A closure typealias for the action to perform when the button is selected.
    public typealias OnSelect = () -> Void

    // MARK: - Properties

    /// The text displayed on the menu button.
    @Published public var text: String

    /// A flag indicating whether the menu button is enabled.
    @Published public var isEnabled: Bool = true

    /// The action to execute when the button is selected.
    private let onSelect: OnSelect

    // MARK: - Lifecycle

    /// Initializes a new `MenuButtonViewModel`.
    ///
    /// - Parameters:
    ///   - text: The text to display on the menu button.
    ///   - onSelect: A closure to execute when the button is selected. Defaults to an empty closure.
    public init(text: String, onSelect: @escaping OnSelect = { }) {
        self.text = text
        self.onSelect = onSelect
    }

}

// MARK: - Public

public extension MenuButtonViewModel {

    /// Executes the selection action associated with the menu button.
    func selected() {
        self.onSelect()
    }

}
