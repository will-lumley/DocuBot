//
//  LLMModel+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension LLMModel {

    static func mock(
        id: Int64? = nil,
        name: String = "Cool Model Name",
        path: String = "/path/to/model",
        size: Int64 = 4000,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) -> LLMModel {
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
