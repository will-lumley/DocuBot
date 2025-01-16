//
//  ToolbarButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

public final class ToolbarButtonViewModel: ObservableObject {

    // MARK: - Types

    public enum WarningState {
        case none
        case warning
        case error
    }

    public typealias OnSelect = () -> Void

    // MARK: - Properties

    @Published public var name: String
    @Published public var symbol: SFSymbol
    @Published public var hoverSymbol: SFSymbol?
    @Published public var isEnabled = true
    @Published public var warningState: WarningState = .none

    public var onSelect: OnSelect

    // MARK: - Lifecycle

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

    func selected() {
        self.onSelect()
    }

}

// MARK: - Equatable

extension ToolbarButtonViewModel: Equatable {

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
