//
//  ChatViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

import CoreGraphics
import SwiftUI

public class ChatViewModel: DocuBotViewModel, Identifiable {

    // MARK: - Types

    // MARK: - Properties

    @Published public var text = ""

    public var id: Int64 {
        self.chat.id ?? -1
    }

    private let chat: Chat

    // MARK: - Lifecycle

    public init(chat: Chat, serviceContainer: ServiceContainer) {
        self.chat = chat
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()
    }

}

// MARK: - Public

public extension ChatViewModel {

    var emptyMessageConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Project.EmptyChat.title,
            subtitle: L10n.Project.EmptyChat.subtitle,
            icon: .message
        )
    }

}

// MARK: - Private

// MARK: - Preview

public extension ChatViewModel {

    static var mock: ChatViewModel {
        .init(
            chat: .init(
                id: 1,
                name: "Chat Name",
                nameType: .userSet,
                projectID: 1,
                createdAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
