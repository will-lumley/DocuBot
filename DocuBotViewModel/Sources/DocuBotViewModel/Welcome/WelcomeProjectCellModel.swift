//
//  WelcomeProjectCellViewModel.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import DocuBotModel
import Foundation

/// A protocol for delegating actions related to project cell models in the Welcome view.
public protocol WelcomeProjectCellViewModelDelegate: AnyObject {
    /// Called when a project should be opened.
    ///
    /// - Parameter project: The `Project` instance to open.
    func openProject(_ project: Project)
}

/// A ViewModel representing a project cell in the Welcome view.
public class WelcomeProjectCellModel: ObservableObject {

    // MARK: - Properties

    /// The `Project` instance associated with this cell.
    let project: Project

    /// A delegate for handling project-related actions.
    public var delegate: WelcomeProjectCellViewModelDelegate?

    // MARK: - Lifecycle

    /// Initializes a new `WelcomeProjectCellModel`.
    ///
    /// - Parameters:
    ///   - project: The `Project` instance this cell represents.
    ///   - delegate: An optional delegate to handle project-related actions.
    public init(
        project: Project,
        delegate: WelcomeProjectCellViewModelDelegate? = nil
    ) {
        self.project = project
        self.delegate = delegate
    }

}

// MARK: - Identifiable

extension WelcomeProjectCellModel: Identifiable {

    /// A unique identifier for the project cell, derived from the project's ID.
    public var id: Int64 {
        self.project.id ?? -1
    }

}

// MARK: - Hashable

extension WelcomeProjectCellModel: Hashable {

    /// Determines equality between two `WelcomeProjectCellModel` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two models represent the same project; otherwise, `false`.
    public static func == (
        lhs: WelcomeProjectCellModel,
        rhs: WelcomeProjectCellModel
    ) -> Bool {
        return lhs.project == rhs.project
    }

    /// Hashes the project into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.project)
    }

}

// MARK: - Public

public extension WelcomeProjectCellModel {

    /// The title of the project, derived from its name.
    var title: String {
        self.project.name
    }

    /// The subtitle of the project, typically its file path.
    var subtitle: String {
        self.project.path
    }

    /// The ViewModel for the "Open" button.
    var openButton: IconButtonViewModel {
        .init(symbol: .arrowForwardCircle, hoverSymbol: .arrowForwardCircleFill) {
            self.delegate?.openProject(self.project)
        }
    }

}
