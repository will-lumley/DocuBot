//
//  MenuButtonViewModel.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import Combine
import Foundation
import SFSafeSymbols

public final class MenuButtonViewModel: ObservableObject {

    // MARK: - Types

    public typealias OnSelect = () -> Void

    // MARK: - Properties

    @Published public var text: String
    @Published public var isEnabled = true

    private let onSelect: OnSelect

    // MARK: - Lifecycle

    init(text: String, onSelect: @escaping OnSelect = { }) {
        self.text = text
        self.onSelect = onSelect
    }

}

// MARK: - Public

public extension MenuButtonViewModel {

    func selected() {
        self.onSelect()
    }

}

// MARK: - Preview Mock

public extension MenuButtonViewModel {

    static var mock: MenuButtonViewModel {
        .init(text: "Hello, World!") { }
    }

}
