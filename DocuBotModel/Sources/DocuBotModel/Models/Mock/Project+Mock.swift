//
//  Project+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation

public extension Project {

    static func mock(
        id: Int64 = 1,
        path: String = "/Users/will/Desktop/Project_1",
        name: String = "Project 1",
        urlBookmarkData: Data = .init(),
        documentationChecksum: String = "123",
        exampleQuestions: [String] = ["foo", "bar"],
        alertStatus: AlertStatus = .error(error: .firstSync),
        needsFullResync: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) -> Project {
        .init(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: .init(),
            documentationCheckSum: documentationChecksum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            needsFullResync: needsFullResync,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
