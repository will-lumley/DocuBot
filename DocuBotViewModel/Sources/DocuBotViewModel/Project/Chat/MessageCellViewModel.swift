//
//  MessageCellViewModel.swift
//
//
//  Created by William Lumley on 26/8/2024.
//

import DocuBotModel
import Foundation

public class MessageCellViewModel: ObservableObject {

    // MARK: - Properties

    let message: Message

    // MARK: - Lifecycle

    init(message: Message) {
        self.message = message
    }

    func configureBindings() {
        
    }

}

// MARK: - Public

public extension MessageCellViewModel {

    var originIsUser: Bool {
        self.message.author == .user
    }

    var messageContent: String {
        self.message.content
    }

}

// MARK: - Identifiable

extension MessageCellViewModel: Identifiable {

    public var id: Int64 {
        self.message.id ?? -1
    }

}

// MARK: - Hashable

extension MessageCellViewModel: Hashable {

    public static func == (lhs: MessageCellViewModel, rhs: MessageCellViewModel) -> Bool {
        return lhs.message == rhs.message
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.message)
    }

}

// MARK: - Preview

public extension MessageCellViewModel {

    static var mock: MessageCellViewModel {
        .init(
            message: .init(
                id: 1,
                content: "Oh hello there",
                author: .docubot,
                chatID: 1,
                createdAt: .now
            )
        )
    }

}
