//
//  ChatViewModel.swift
//
//
//  Created by William Lumley on 3/7/2024.
//

import Foundation

public class ChatViewModel: ObservableObject {

    // MARK: - Properties

    let text: String

    // MARK: - Lifecycle

    public init(text: String) {
        self.text = text
    }
    
}

// MARK: - Preview

public extension ChatViewModel {

    static var mock: ChatViewModel {
        .init(text: "fii")
    }

}
