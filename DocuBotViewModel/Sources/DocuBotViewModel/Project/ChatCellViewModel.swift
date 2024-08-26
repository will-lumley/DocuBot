//
//  ChatCellViewModel.swift
//
//
//  Created by William Lumley on 26/8/2024.
//

import DocuBotModel
import Foundation

public protocol ChatCellViewModelDelegate {
    func chatSelected(_ project: Chat)
}

public class ChatCellViewModel: ObservableObject {

    // MARK: - Types

    public enum State {
        case display
        case rename
    }

    // MARK: - Properties

    @Published public var state: State = .display
    @Published public var renameTitle = ""

    let chat: Chat
    public var delegate: ChatCellViewModelDelegate?

    // MARK: - Lifecycle

    init(chat: Chat, delegate: ChatCellViewModelDelegate? = nil) {
        self.chat = chat
        self.delegate = delegate
    }

    func configureBindings() {
        
    }

}

// MARK: - Identifiable

extension ChatCellViewModel: Identifiable {

    public var id: Int {
        self.chat.id ?? -1
    }

}

// MARK: - Public

public extension ChatCellViewModel {

    var title: String {
        self.chat.name
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
