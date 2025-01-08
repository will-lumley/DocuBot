//
//  Document+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 19/11/2024.
//

import Foundation

public extension Document {

    /// Creates a mock instance of `Document` for testing purposes.
    ///
    /// This method generates a `Document` instance with predefined or customizable default values,
    /// useful for unit testing or prototyping.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the document (optional; default is `nil`).
    ///   - url: The file URL for the document (default is `"/path/to/file.md"`).
    ///   - fileFormat: The format of the document, as defined
    ///   in `ProjectSettings.DocumentationFormat` (default is `.rtf`).
    ///   - content: The content of the document as a string (default is `"content1"`).
    ///   - checksum: A checksum representing the document's content (default is `"checksum"`).
    ///   - projectID: The identifier of the project this document belongs to (default is `1`).
    ///   - embeddings: An optional array of `Embedding` objects for the document (default is `nil`).
    ///   - createdAt: The timestamp indicating when the document was created (default is the current date).
    ///   - updatedAt: The timestamp indicating when the document was last
    ///   updated (default is the current date).
    ///
    /// - Returns: A `Document` instance populated with the specified or default values.
    ///
    /// # Example
    /// ```swift
    /// let mockDocument = Document.mock(
    ///     id: 101,
    ///     url: URL(filePath: "/projects/docs/sample.md"),
    ///     fileFormat: .md,
    ///     content: "Sample content",
    ///     checksum: "abc123",
    ///     projectID: 42,
    ///     embeddings: [
    ///         Document.Embedding(chunk: "Sample chunk", embedding: [0.1, 0.2, 0.3])
    ///     ],
    ///     createdAt: Date(timeIntervalSince1970: 0),
    ///     updatedAt: Date()
    /// )
    /// ```
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
