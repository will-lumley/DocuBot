//
//  ChatViewModel.swift
//
//
//  Created by William Lumley on 3/7/2024.
//

import DocuBotService
import Foundation

public class ChatViewModel: DocuBotViewModel {

    // MARK: - Properties

    let text: String

    // MARK: - Lifecycle

    public init(text: String, serviceContainer: ServiceContainer) {
        self.text = text
        super.init(serviceContainer: serviceContainer)
    }
    
}

// MARK: - Preview

public extension ChatViewModel {

    static var mock: ChatViewModel {
        .init(text: "foo", serviceContainer: .mock)
    }

}
