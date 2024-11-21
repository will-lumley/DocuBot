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

public class WelcomeProjectCellModel: ObservableObject {

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

extension WelcomeProjectCellModel: Identifiable {

    public var id: Int64 {
        self.project.id ?? Int64(-1)
    }

}

// MARK: - Hashable

extension WelcomeProjectCellModel: Hashable {

    public static func == (lhs: WelcomeProjectCellModel, rhs: WelcomeProjectCellModel) -> Bool {
        return lhs.project == rhs.project
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.project)
    }

}

// MARK: - Public

public extension WelcomeProjectCellModel {

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

public extension WelcomeProjectCellModel {

    static var mock: WelcomeProjectCellModel {
        .init(
            project: .mock()
        )
    }

}
