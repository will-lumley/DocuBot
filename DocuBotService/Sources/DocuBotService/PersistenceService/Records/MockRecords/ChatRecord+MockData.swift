//
//  ChatRecord+MockData.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation

extension ChatRecord {

    static func mocks() -> [ChatRecord] {
        return [
            .mock(
                id: 1,
                name: "Main",
                project: 1,
                createdAt: .now
            ),
            .mock(
                id: 2,
                name: "Main",
                project: 2,
                createdAt: .now
            ),
            .mock(
                id: 3,
                name: "Main",
                project: 3,
                createdAt: .now
            )
        ]
    }

    static func mock(
        id: Int64 = 0,
        name: String = "",
        project: Int64 = 0,
        createdAt: Date = Date()
    ) -> ChatRecord {
        .init(
            id: id,
            name: name,
            nameType: .automatic,
            project: project,
            createdAt: createdAt
        )
    }

}
