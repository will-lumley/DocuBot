//
//  ChatCellViewModel.swift
//
//
//  Created by William Lumley on 26/8/2024.
//

import DocuBotModel
import Foundation

public protocol ChatCellViewModelDelegate {
    func chatRenamed(_ chat: Chat, _ newName: String)
}

public class ChatCellViewModel: ObservableObject {

    // MARK: - Types

    // MARK: - Properties

    @Published public var renameTitle = ""

    let chat: Chat
    public var delegate: ChatCellViewModelDelegate?

    // MARK: - Lifecycle

    init(chat: Chat, delegate: ChatCellViewModelDelegate? = nil) {
        self.chat = chat
        self.renameTitle = self.chat.name
        self.delegate = delegate
    }

    func configureBindings() {
        
    }

}

// MARK: - Identifiable

extension ChatCellViewModel: Identifiable {

    public var id: Int64 {
        self.chat.id ?? -1
    }

}

// MARK: - Public

public extension ChatCellViewModel {

    func renameTextFieldEntered() {
        self.delegate?.chatRenamed(self.chat, self.renameTitle)
    }

}

// MARK: - Hashable

extension ChatCellViewModel: Hashable {

    public static func == (lhs: ChatCellViewModel, rhs: ChatCellViewModel) -> Bool {
        return lhs.chat == rhs.chat
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.chat)
    }

}

// MARK: - Preview

public extension ChatCellViewModel {

    static var mock: ChatCellViewModel {
        .init(
            chat: .init(
                id: 0,
                name: "Hello There!",
                nameType: .userSet,
                projectID: 1,
                createdAt: .now
            ),
            delegate: nil
        )
    }

}
