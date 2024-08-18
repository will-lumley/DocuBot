//
//  ProjectPickerViewModel.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

// Having to import AppKit is very sad, but necessary to open the URL
import AppKit
import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation

public class ProjectPickerViewModel: DocuBotViewModel {

    // MARK: - Types

    public typealias OnCloseWindow = () -> Void
    public typealias OnDelete = () -> Void

    public enum OpenWindow {
        case createProject(CreateProjectViewModel.OpenWindowPackage)
    }

    // MARK: - Properties

    /// The closure that will be called when the CloseWindow button is selected
    private let onCloseWindow: OnCloseWindow

    /// The ViewModels that represent our project cells/rows
    @Published public var projectCellViewModels = [ProjectPickerCellViewModel]()

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// This will be called when this ViewModel wants the UI layer to close/dismiss the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// This closure will be called if a user confirms they want to delete a project
    private var deleteProjectAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteProjectConfirmationDialogPresented = false

    // MARK: - Lifecycle

    public init(onCloseWindow: @escaping OnCloseWindow, serviceContainer: ServiceContainer) {
        self.onCloseWindow = onCloseWindow
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // Connect our ProjectCellViewModels to our DB layer
        persistenceService.getProjects()
            .map { $0.map { ProjectPickerCellViewModel(project: $0, delegate: self) } }
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

    var loadNewProjectButtonTitle: String {
        L10n.ProjectPicker.loadNewProject
    }

    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill, onSelect: onCloseWindow)
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

    var deleteProjectConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.ProjectPicker.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.ProjectPicker.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        self.deleteProjectAction?()
                    }
                ),
                .init(
                    title: L10n.ProjectPicker.Delete.Confirmation.cancelButton,
                    role: .cancel,
                    action: { }
                ),
            ]
        )
    }

    func contextMenuConfigurations(for cell: ProjectPickerCellViewModel) -> [ContextMenuConfiguration] {
        return [
            .init(text: L10n.ProjectPicker.ProjectContextMenu.open) {
                self.open(project: cell.project)
            },
            .init(text: L10n.ProjectPicker.ProjectContextMenu.delete) {
                self.promptDeletion(project: cell.project)
            },
            .init(text: L10n.ProjectPicker.ProjectContextMenu.showInFinder) {
                self.showInFinder(project: cell.project)
            }
        ]
    }

    func delete(project: Project) {
        Task {
            do {
                let success = try await persistenceService.delete(project: project)
                if success == false {
                    print("Error: no deleting")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

    func selectDirectoryForNewProject(_ url: URL) {
        print("URL: \(url)")

        // Close our window
        self.onDismiss.send(())

        // Open the CreateProject window
        self.onOpen.send(
            .createProject(.init(directory: url))
        )
    }

}

// MARK: - Private

private extension ProjectPickerViewModel {

    func open(project: Project) {
        // TODO: Implement this
        print("Opened: \(project.name)")
    }

    func promptDeletion(project: Project) {
        self.deleteProjectConfirmationDialogPresented = true
        self.deleteProjectAction = {
            self.delete(project: project)
        }
    }

    func showInFinder(project: Project) {
        let url = URL(filePath: project.path)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

}

// MARK: - ProjectPickerCellViewModelDelegate

extension ProjectPickerViewModel: ProjectPickerCellViewModelDelegate {

    public func openProject(_ project: Project) {
        self.open(project: project)
    }

}

// MARK: - Preview

public extension ProjectPickerViewModel {

    static var mock: ProjectPickerViewModel {
        .init(onCloseWindow: { }, serviceContainer: .mock)
    }

}
