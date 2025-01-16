//
//  ProjectPickerViewModel.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

// Having to import AppKit is very sad, but necessary to open the URL
import AppKit
import DocuBotService
import DocuBotToolbox
import Foundation

public class ProjectPickerViewModel: DocuBotViewModel {

    // MARK: - Types

    public typealias OnCloseWindow = () -> Void

    // MARK: - Properties

    /// The Cell ViewModel that has been selected by our user
    @Published public var selectedProject: ProjectPickerCellViewModel?

    /// The closure that will be called when the CloseWindow button is selected
    private let onCloseWindow: OnCloseWindow

    /// The ViewModels that represent our project cells/rows
    @Published public var projectCellViewModels = [ProjectPickerCellViewModel]()

    // MARK: - Lifecycle

    public init(onCloseWindow: @escaping OnCloseWindow, serviceContainer: ServiceContainer) {
        self.onCloseWindow = onCloseWindow
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        self.$selectedProject
            .sink {
                print("Selected Project: \($0?.title)")
            }
            .store(in: &cancellables)

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
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill, onSelect: onCloseWindow)
    }

    var loadNewProjectButton: MenuButtonViewModel {
        .init(text: L10n.ProjectPicker.loadNewProject) {
            print("LOAD NEW PROJECT")
        }
    }

    var viewSourceCodeButton: MenuButtonViewModel {
        .init(text: L10n.ProjectPicker.viewSourceCode) {
            guard let url = URL(string: Secrets.AppInfo.sourceCodeURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    var emailDeveloper: MenuButtonViewModel {
        .init(text: L10n.ProjectPicker.emailDeveloper) {
            let service = NSSharingService(named: NSSharingService.Name.composeEmail)
            service?.recipients = [Secrets.AppInfo.developerEmail]
            service?.perform(withItems: [""])
        }
    }

    var emptyProjectConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.ProjectPicker.emptyProjectTitle,
            subtitle: L10n.ProjectPicker.emptyProjectSubtitle,
            icon: .booksVerticalFill
        )
    }

}

// MARK: - Private

private extension ProjectPickerViewModel {

}

// MARK: - Preview

public extension ProjectPickerViewModel {

    static var mock: ProjectPickerViewModel {
        .init(onCloseWindow: { }, serviceContainer: .mock)
    }

}
