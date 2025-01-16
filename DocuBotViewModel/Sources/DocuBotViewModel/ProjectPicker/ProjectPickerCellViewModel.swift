//
//  ProjectPickerCellViewModel.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation
import DocuBotModel

public protocol ProjectPickerCellViewModelDelegate {
    func openProject(_ project: Project)
}

public class ProjectPickerCellViewModel: ObservableObject {

    // MARK: - Properties

    let project: Project
    public var delegate: ProjectPickerCellViewModelDelegate?

    // MARK: - Lifecycle

    init(project: Project, delegate: ProjectPickerCellViewModelDelegate? = nil) {
        self.project = project
        self.delegate = delegate
    }

}

// MARK: - Identifiable

extension ProjectPickerCellViewModel: Identifiable {

    public var id: Int {
        self.project.id
    }

}

// MARK: - Hashable

extension ProjectPickerCellViewModel: Hashable {

    public static func == (lhs: ProjectPickerCellViewModel, rhs: ProjectPickerCellViewModel) -> Bool {
        return lhs.project == rhs.project
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.project)
    }

}

// MARK: - Public

public extension ProjectPickerCellViewModel {

    var title: String {
        self.project.name
    }

    var subtitle: String {
        self.project.path
    }

    func openButtonSelected() {
        self.delegate?.openProject(self.project)
    }

}

// MARK: - Preview

public extension ProjectPickerCellViewModel {

    static var mock: ProjectPickerCellViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project_1",
                documentationChecksum: "123",
                createdAt: .now,
                updatedAt: .now
            )
        )
    }

}
