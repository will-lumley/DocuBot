//
//  ProjectQuestionViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 18/10/2024.
//

import DocuBotService
import Foundation

public class ProjectQuestionViewModel: ObservableObject {

    // MARK: - Types

    public typealias OnSelect = (_ content: String) -> Void

    // MARK: - Properties

    public let content: String
    private let onSelect: OnSelect

    // MARK: - Lifecycle

    public init(content: String, onSelect: @escaping OnSelect) {
        self.content = content
        self.onSelect = onSelect
    }

    public func select() {
        self.onSelect(self.content)
    }

}

// MARK: - Identifable

extension ProjectQuestionViewModel: Identifiable {

    public var id: String {
        self.content
    }

}

// MARK: - Equatable

extension ProjectQuestionViewModel: Equatable {

    public static func == (lhs: ProjectQuestionViewModel, rhs: ProjectQuestionViewModel) -> Bool {
        return lhs.content == rhs.content
    }

}
