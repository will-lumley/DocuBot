//
//  ChatViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation

public class ChatViewModel: DocuBotViewModel, Identifiable {

    // MARK: - Properties

    @Published public var chatText = ""
    @Published public var messages: [MessageCellViewModel]?

    /// This publisher is called whenever a new message is received
    @Published public var newMessagePublisher = PassthroughSubject<MessageCellViewModel, Never>()

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

        // Connect our MessageCellViewModels to our DB layer
        persistenceService.getMessages(for: self.chat)
            .map { $0.map { MessageCellViewModel(message: $0) } }
            .replaceError(with: [])
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
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

    func enterSelected() {
        // If we don't have a chat ID, bail (this should never happen)
        guard let chatID = self.chat.id else {
            return
        }

        guard self.chatText.isEmpty == false else {
            return
        }

        // Create our message
        let message = Message(
            content: self.chatText,
            author: .user,
            chatID: chatID,
            createdAt: .now
        )

        Task {
            do {
                // Insert the message into the database
                _ = try await persistenceService.insert(message: message)

                // Clear out the TextView chat
                DispatchQueue.main.async {
                    self.chatText = ""
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
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
