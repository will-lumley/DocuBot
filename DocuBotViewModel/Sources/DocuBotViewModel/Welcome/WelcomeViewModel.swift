//
//  WelcomeViewModel.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

// Having to import AppKit makes me very sad, but necessary to open the URL
import AppKit
import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation

public class WelcomeViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    public typealias OnDelete = () -> Void

    public enum OpenWindow {
        case project(ProjectViewModel.OpenWindowPackage)
    }

    // MARK: - Properties

    /// The ViewModels that represent our project cells/rows
    @Published public var projects: [WelcomeProjectCellViewModel]?

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// This will be called when this ViewModel wants the UI layer to close/dismiss the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// This closure will be called if a user confirms they want to delete a project
    private var deleteProjectAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteProjectConfirmationDialogPresented = false

    @Published public var alertConfiguration: AlertConfiguration?

    @Published public var createProjectViewModel: ConfigureProjectViewModel?

    // MARK: - Lifecycle

    override public func configureBindings() {
        super.configureBindings()

        // Connect our ProjectCellViewModels to our DB layer
        persistenceService.getProjects()
            .map { $0.map { WelcomeProjectCellViewModel(project: $0, delegate: self) } }
            .replaceError(with: [])
            .assign(to: &$projects)
    }

}

// MARK: - Public

public extension WelcomeViewModel {

    var title: String {
        L10n.Welcome.title
    }

    var subtitle1: String {
        L10n.Welcome.subtitle1
    }

    var subtitle2: String {
        L10n.Welcome.subtitle2(Device.versionNumber, Device.buildNumber)
    }

    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill) {
            self.onDismiss.send(())
        }
    }

    var newProjectButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.loadNewProject) {
            // Close our window
            // self.onDismiss.send(())

            // Open the CreateProject
            self.createProjectViewModel = .init(serviceContainer: self.serviceContainer)
        }
    }

    var viewSourceCodeButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.viewSourceCode) {
            guard let url = URL(string: Secrets.AppInfo.sourceCodeURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    var emailDeveloper: MenuButtonViewModel {
        .init(text: L10n.Welcome.emailDeveloper) {
            let service = NSSharingService(named: NSSharingService.Name.composeEmail)
            service?.recipients = [Secrets.AppInfo.developerEmail]
            service?.perform(withItems: [""])
        }
    }

    var emptyProjectConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Welcome.emptyProjectTitle,
            subtitle: L10n.Welcome.emptyProjectSubtitle,
            icon: .booksVerticalFill
        )
    }

    var deleteProjectConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.Welcome.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.Welcome.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        self.deleteProjectAction?()
                    }
                ),
                .init(
                    title: L10n.Welcome.Delete.Confirmation.cancelButton,
                    role: .cancel,
                    action: { }
                )
            ]
        )
    }

    func contextMenuConfigurations(
        for cell: WelcomeProjectCellViewModel
    ) -> [ContextMenuConfiguration] {
        return [
            .init(text: L10n.Welcome.ProjectContextMenu.open) {
                self.open(project: cell.project)
            },
            .init(text: L10n.Welcome.ProjectContextMenu.delete) {
                self.promptDeletion(project: cell.project)
            },
            .init(text: L10n.Welcome.ProjectContextMenu.showInFinder) {
                self.showInFinder(project: cell.project)
            }
        ]
    }

    func delete(project: Project) {
        Task {
            do {
                let success = try await persistenceService.delete(project: project)
                if success == false {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Welcome.FailedToDelete.title,
                        message: L10n.Error.Welcome.FailedToDelete.message
                    )
                }
            } catch {
                self.alertConfiguration = .init(
                    title: L10n.Error.Welcome.FailedToDelete.title,
                    message: error.description
                )
            }
        }
    }

}

// MARK: - Private

private extension WelcomeViewModel {

    func open(project: Project) {
        // Close our window
        self.onDismiss.send(())

        // Open the CreateProject window
        self.onOpen.send(
            .project(.init(project: project))
        )
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

// MARK: - WelcomeProjectCellViewModelDelegate

extension WelcomeViewModel: WelcomeProjectCellViewModelDelegate {

    public func openProject(_ project: Project) {
        self.open(project: project)
    }

}

// MARK: - Preview

public extension WelcomeViewModel {

    static var mock: WelcomeViewModel {
        .init(serviceContainer: .mock)
    }

}
