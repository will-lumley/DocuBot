//
//  EmptyListConfiguration.swift
//
//
//  Created by William Lumley on 24/7/2024.
//

import Foundation
import SFSafeSymbols

public struct EmptyListConfiguration {
    public let title: String
    public let subtitle: String
    public let icon: SFSymbol
}

// MARK: - Preview

public extension EmptyListConfiguration {

    static var mock: EmptyListConfiguration {
        .init(
            title: "Empty Title Empty",
            subtitle: "Empty Subtitle Empty Subtitle Empty Subtitle",
            icon: .booksVerticalFill
        )
    }

}
