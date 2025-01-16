//
//  Project+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

public extension Project {

    static var mock: Self {
        .init(
            id: 1,
            path: "/Users/will/Desktop/Project_1",
            name: "Project 1",
            urlBookmarkData: .init(),
            documentationCheckSum: "123",
            exampleQuestions: [
                "Example example example",
                "Example example example"
            ],
            alertStatus: .none,
            needsFullResync: true,
            createdAt: .now,
            updatedAt: .now
        )
    }

}
