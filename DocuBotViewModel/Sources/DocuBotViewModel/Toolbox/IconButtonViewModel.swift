//
//  IconButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

public final class IconButtonViewModel: ObservableObject {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    // MARK: - Properties

    @Published public var symbol: SFSymbol
    @Published public var hoverSymbol: SFSymbol?
    @Published public var isEnabled = true

    private let onSelect: OnSelect

    // MARK: - Lifecycle

    init(
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

    func selected() {
        self.onSelect()
    }

}

// MARK: - Preview Mock

public extension IconButtonViewModel {

    static var mock: IconButtonViewModel {
        .init(symbol: .gear) { }
    }

}
