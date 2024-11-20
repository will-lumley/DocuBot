//
//  Document+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension Document {

    static func mock(
        id: Int64? = nil,
        url: URL = .init(filePath: "/path/to/file.md"),
        fileFormat: ProjectSettings.DocumentationFormat = .rtf,
        content: String = "content1",
        checksum: String = "checksum",
        projectID: Int64 = 1,
        embeddings: [Embedding]? = nil,
        createdAt: Date = .init(),
        updatedAt: Date = .init()
    ) -> Document {
        .init(
            id: id,
            url: url,
            fileFormat: fileFormat,
            content: content,
            checksum: checksum,
            projectID: projectID,
            embeddings: embeddings,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
