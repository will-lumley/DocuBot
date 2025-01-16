//
//  ModelRecord+MockData.swift
//  DocuBotService
//
//  Created by William Lumley on 30/10/2024.
//

import Foundation

extension ModelRecord {

    static func mocks() -> [ModelRecord] {
        return [
            .mock(
                id: 1,
                name: "Model 1",
                path: "/Users/will/Desktop/model_1",
                size: 150
            ),
            .mock(
                id: 2,
                name: "Model 2",
                path: "/Users/will/Desktop/model_1",
                size: 150
            ),
            .mock(
                id: 3,
                name: "Model 3",
                path: "/Users/will/Desktop/model_1",
                size: 150
            )
        ]
    }

    static func mock(
        id: Int64 = 0,
        name: String = "",
        path: String = "",
        size: Int64 = 100,
        createdAt: Date = .init(),
        updatedAt: Date = .init()
    ) -> ModelRecord {
        .init(
            id: id,
            name: name,
            path: path,
            size: size,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
