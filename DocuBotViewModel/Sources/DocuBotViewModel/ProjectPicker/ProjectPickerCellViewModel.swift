//
//  ProjectPickerCellViewModel.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Foundation
import DocuBotModel

public class ProjectPickerCellViewModel: ObservableObject {

    // MARK: - Properties

    private let project: Project

    // MARK: - Lifecycle

    init(project: Project) {
        self.project = project
    }

}

// MARK: - Identifiable

extension ProjectPickerCellViewModel: Identifiable {

    public var id: Int {
        self.project.id
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
}

// MARK: - Preview

public extension ProjectPickerCellViewModel {

    static var mock: ProjectPickerCellViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project_1",
                createdAt: .now
            )
        )
    }

}
