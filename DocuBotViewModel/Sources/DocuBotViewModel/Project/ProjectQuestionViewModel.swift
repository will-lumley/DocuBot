//
//  ProjectQuestionViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 18/10/2024.
//

import DocuBotService
import Foundation

/// A ViewModel representing a question associated with a project in the DocuBot application.
public class ProjectQuestionViewModel: ObservableObject {

    // MARK: - Types

    /// A closure typealias for handling the selection of a question.
    ///
    /// - Parameter content: The content of the selected question.
    public typealias OnSelect = (_ content: String) -> Void

    // MARK: - Properties

    /// The content of the question.
    public let content: String

    /// A closure to execute when the question is selected.
    private let onSelect: OnSelect

    // MARK: - Lifecycle

    /// Initializes a new `ProjectQuestionViewModel`.
    ///
    /// - Parameters:
    ///   - content: The content of the question.
    ///   - onSelect: A closure to execute when the question is selected.
    public init(content: String, onSelect: @escaping OnSelect) {
        self.content = content
        self.onSelect = onSelect
    }

    /// Executes the `onSelect` closure with the question's content.
    public func select() {
        self.onSelect(self.content)
    }

}

// MARK: - Identifiable

extension ProjectQuestionViewModel: Identifiable {

    /// A unique identifier for the question, derived from its content.
    public var id: String {
        self.content
    }

}

// MARK: - Equatable

extension ProjectQuestionViewModel: Equatable {

    /// Determines equality between two `ProjectQuestionViewModel` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if both instances have the same content; otherwise, `false`.
    public static func == (lhs: ProjectQuestionViewModel, rhs: ProjectQuestionViewModel) -> Bool {
        return lhs.content == rhs.content
    }

}
