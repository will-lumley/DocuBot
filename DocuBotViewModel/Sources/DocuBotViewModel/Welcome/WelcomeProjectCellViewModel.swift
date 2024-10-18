//
//  WelcomeProjectCellViewModel.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import DocuBotModel
import Foundation

public protocol WelcomeProjectCellViewModelDelegate: AnyObject {
    func openProject(_ project: Project)
}

public class WelcomeProjectCellViewModel: ObservableObject {

    // MARK: - Properties

    let project: Project
    public var delegate: WelcomeProjectCellViewModelDelegate?

    // MARK: - Lifecycle

    init(project: Project, delegate: WelcomeProjectCellViewModelDelegate? = nil) {
        self.project = project
        self.delegate = delegate
    }

}

// MARK: - Identifiable

extension WelcomeProjectCellViewModel: Identifiable {

    public var id: Int64 {
        self.project.id ?? Int64(-1)
    }

}

// MARK: - Hashable

extension WelcomeProjectCellViewModel: Hashable {

    public static func == (lhs: WelcomeProjectCellViewModel, rhs: WelcomeProjectCellViewModel) -> Bool {
        return lhs.project == rhs.project
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.project)
    }

}

// MARK: - Public

public extension WelcomeProjectCellViewModel {

    var title: String {
        self.project.name
    }

    var subtitle: String {
        self.project.path
    }

    var openButton: IconButtonViewModel {
        .init(symbol: .arrowForwardCircle, hoverSymbol: .arrowForwardCircleFill) {
            self.delegate?.openProject(self.project)
        }
    }

}

// MARK: - Preview

public extension WelcomeProjectCellViewModel {

    static var mock: WelcomeProjectCellViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project_1",
                isDirty: false,
                urlBookmarkData: nil,
                urlBookmarkDataIsStale: true,
                exampleQuestions: [],
                createdAt: .now,
                updatedAt: .now
            )
        )
    }

}
