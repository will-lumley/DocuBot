//
//  Project+Mock.swift
//  DocuBotModel
//
//  Created by William Lumley on 29/10/2024.
//

import Foundation

public extension Project {

    /// Creates a mock instance of `Project` for testing purposes.
    ///
    /// This method generates a `Project` instance with predefined or customizable
    /// default values, which is particularly useful for unit testing or prototyping.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the project (default is `1`).
    ///   - path: The file path of the project (default is `"/Users/will/Desktop/Project_1"`).
    ///   - name: The name of the project (default is `"Project 1"`).
    ///   - urlBookmarkData: The bookmark data for secure access to the project's
    ///   directory (default is an empty `Data` object).
    ///   - documentationChecksum: A checksum representing the project's documentation
    ///   content (default is `"123"`).
    ///   - exampleQuestions: Example questions relevant to the project (default is `["foo", "bar"]`).
    ///   - alertStatus: The alert status for the project (default is `.none`).
    ///   - createdAt: The creation timestamp for the project (default is the current date).
    ///   - updatedAt: The last updated timestamp for the project (default is the current date).
    ///
    /// - Returns: A `Project` instance populated with the specified or default values.
    ///
    /// # Example
    /// ```swift
    /// let mockProject = Project.mock(
    ///     id: 42,
    ///     name: "Test Project",
    ///     path: "/Users/testuser/Projects/TestProject",
    ///     exampleQuestions: ["What is this?", "How does it work?"],
    ///     alertStatus: .warning(warning: .isDirty)
    /// )
    /// ```
    static func mock(
        id: Int64 = 1,
        path: String = "/Users/will/Desktop/Project_1",
        name: String = "Project 1",
        urlBookmarkData: Data = .init(),
        documentationChecksum: String = "123",
        exampleQuestions: [String] = ["foo", "bar"],
        alertStatus: AlertStatus = .none,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) -> Project {
        .init(
            id: id,
            path: path,
            name: name,
            urlBookmarkData: urlBookmarkData,
            documentationCheckSum: documentationChecksum,
            exampleQuestions: exampleQuestions,
            alertStatus: alertStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}
