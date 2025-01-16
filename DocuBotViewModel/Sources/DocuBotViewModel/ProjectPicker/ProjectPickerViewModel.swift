//
//  ProjectPickerViewModel.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotService
import Foundation

public class ProjectPickerViewModel: DocuBotViewModel {

    // MARK: - Types

    public typealias OnCloseWindow = () -> Void

    // MARK: - Properties

    private let onCloseWindow: OnCloseWindow

    @Published public var projectCellViewModels = [ProjectPickerCellViewModel]()

    // MARK: - Lifecycle

    public init(onCloseWindow: @escaping OnCloseWindow, serviceContainer: ServiceContainer) {
        self.onCloseWindow = onCloseWindow
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // Connect our ProjectCellViewModels to our DB layer
        persistenceService.getProjects()
            .map { $0.map(ProjectPickerCellViewModel.init) }
            .replaceError(with: [])
            .assign(to: &$projectCellViewModels)
    }

}

// MARK: - Public

public extension ProjectPickerViewModel {

    var title: String {
        L10n.ProjectPicker.title
    }

    var subtitle1: String {
        L10n.ProjectPicker.subtitle1
    }

    var subtitle2: String {
        let versionNumber = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1"
        let buildNumber = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "1.0"

        return L10n.ProjectPicker.subtitle2(versionNumber, buildNumber)
    }

    var closeButton: IconButtonViewModel {
        .init(
            symbol: .xmarkCircle,
            hoverSymbol: .xmarkCircleFill,
            onSelect: closeButtonSelected
        )
    }

}

// MARK: - Private

private extension ProjectPickerViewModel {

    func closeButtonSelected() {
        self.onCloseWindow()
    }

}

// MARK: - Preview

public extension ProjectPickerViewModel {

    static var mock: ProjectPickerViewModel {
        .init(onCloseWindow: { }, serviceContainer: .mock)
    }

}
