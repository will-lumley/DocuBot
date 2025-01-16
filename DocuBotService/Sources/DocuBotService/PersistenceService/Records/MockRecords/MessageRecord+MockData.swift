//
//  MessageRecord+MockData.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation

extension MessageRecord {

    static func mocks() -> [MessageRecord] {
        return [
            .mock(
                id: 1,
                content: "Hello friend",
                author: .user,
                chat: 1,
                createdAt: .now
            ),
            .mock(
                id: 2,
                content: "Hello there, I am DocuBot",
                author: .docubot,
                chat: 1,
                createdAt: .now
            ),
            .mock(
                id: 3,
                content: "What can you do?",
                author: .user,
                chat: 1,
                createdAt: .now
            ),
            .mock(
                id: 4,
                content: "Help with documentation, bucko",
                author: .docubot,
                chat: 1,
                createdAt: .now
            ),

            .mock(
                id: 5,
                content: "Hello friend",
                author: .user,
                chat: 2,
                createdAt: .now
            ),
            .mock(
                id: 6,
                content: "Hello there, I am DocuBot",
                author: .docubot,
                chat: 2,
                createdAt: .now
            ),
            .mock(
                id: 7,
                content: "What can you do?",
                author: .user,
                chat: 2,
                createdAt: .now
            ),
            .mock(
                id: 8,
                content: "Help with documentation, bucko",
                author: .docubot,
                chat: 2,
                createdAt: .now
            ),

            .mock(
                id: 9,
                content: "Hello friend",
                author: .user,
                chat: 3,
                createdAt: .now
            ),
            .mock(
                id: 10,
                content: "Hello there, I am DocuBot",
                author: .docubot,
                chat: 3,
                createdAt: .now
            ),
            .mock(
                id: 11,
                content: "What can you do?",
                author: .user,
                chat: 3,
                createdAt: .now
            ),
            .mock(
                id: 12,
                content: "Help with documentation, bucko",
                author: .docubot,
                chat: 3,
                createdAt: .now
            ),
        ]
    }

    static func mock(
        id: Int64 = 0,
        content: String = "",
        author: Author = .user,
        chat: Int64 = Int64(0),
        createdAt: Date = Date()
    ) -> MessageRecord {
        .init(
            id: id,
            content: content,
            author: author,
            chat: chat,
            createdAt: createdAt
        )
    }

}
