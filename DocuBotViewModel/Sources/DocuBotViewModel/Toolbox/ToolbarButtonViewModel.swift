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
    }

    public typealias OnSelect = () -> Void

    // MARK: - Properties

    @Published public var name: String?
    @Published public var symbol: SFSymbol
    @Published public var hoverSymbol: SFSymbol?
    @Published public var isEnabled = true
    @Published public var warningState: WarningState = .none

    public var onSelect: OnSelect

    // MARK: - Lifecycle

    init(
        name: String? = nil,
        symbol: SFSymbol,
        hoverSymbol: SFSymbol? = nil,
        onSelect: @escaping OnSelect = { }
    ) {
        self.name = name
        self.symbol = symbol
        self.hoverSymbol = hoverSymbol
        self.onSelect = onSelect
    }

}

// MARK: - Public

public extension ToolbarButtonViewModel {

    func selected() {
        self.onSelect()
    }

}

// MARK: - Preview Mock

public extension ToolbarButtonViewModel {

    static var mock: ToolbarButtonViewModel {
        .init(name: "Settings", symbol: .gear) { }
    }

}
