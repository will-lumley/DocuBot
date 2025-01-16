//
//  ProjectRecord+MockData.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation

extension ProjectRecord {

    static func mocks() -> [ProjectRecord] {
        return [
            .mock(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 1"
            ),
            .mock(
                id: 2,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 2"
            ),
            .mock(
                id: 3,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 3"
            )
        ]
    }

    static func mock(
        id: Int64 = 0,
        path: String = "",
        name: String = "",
        urlBookmarkData: Data? = nil,
        urlBookmarkDataIsStale: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> ProjectRecord {
        .init(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            urlBookmarkDataIsStale: urlBookmarkDataIsStale,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
