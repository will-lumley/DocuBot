//
//  Project+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

public extension Project {

    static func mock() -> Project {
        .init(
            path: "/Users/will/Desktop/Project_1",
            name: "Project 1",
            urlBookmarkData: .init(),
            documentationCheckSum: "123",
            exampleQuestions: [
                "Example example example",
                "Example example example"
            ],
            alertStatus: .error(error: .firstSync),
            needsFullResync: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

}
