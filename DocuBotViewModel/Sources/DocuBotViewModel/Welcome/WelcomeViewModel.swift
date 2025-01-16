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

/// The `WelcomeViewModel` is responsible for managing the data and actions
/// for the Welcome screen of the application. It provides state and bindings
/// for UI components and handles user interactions.
public class WelcomeViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// An enumeration representing the types of windows that can be opened from the Welcome screen.
    public enum OpenWindow: Hashable {
        /// Opens the Model Manager window.
        case modelManager
        /// Opens a specific project window with the given configuration.
        case project(ProjectViewModel.OpenWindowPackage)
    }

    /// An enumeration representing the state of the list view displayed on the Welcome screen.
    public enum ListViewState: Equatable {
        /// No state is currently active.
        case none
        /// A list of projects is available to display.
        case listProjects([WelcomeProjectCellModel])
        /// No projects are available to display.
        case noProjects(EmptyListConfiguration)
        /// No models are available to display.
        case noModels(EmptyListConfiguration)
    }

    /// A typealias for the closure called when a project is deleted.
    public typealias OnDelete = () async -> Void

    // MARK: - Properties

    /// A subject that publishes events when a new window should be opened.
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// A subject that publishes events when the current window should be dismissed.
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// The closure to execute when a user confirms they want to delete a project.
    var deleteProjectAction: OnDelete?

    /// A flag indicating whether the Delete Project confirmation dialog is presented.
    @Published public var deleteProjectConfirmationDialogPresented = false

    /// The configuration of the alert to be displayed to the user.
    @Published public var alertConfiguration: AlertConfiguration?

    /// The ViewModel for configuring a project.
    @Published public var configureProjectViewModel: ConfigureProjectViewModel?

    /// The current state of the list view.
    @Published public var listState: ListViewState = .none

    // MARK: - Lifecycle

    /// Configures the bindings for this ViewModel.
    override public func configureBindings() {
        super.configureBindings()

        let projectsPublisher = persistenceService.getProjects()
            .replaceError(with: [])
        let modelCountPublisher = persistenceService.getModelCount()
            .replaceNil(with: 0)

        Publishers.CombineLatest(projectsPublisher, modelCountPublisher)
            .map { projects, modelCount -> ([WelcomeProjectCellModel], Int?) in
                let projectCellModels = projects.map {
                    WelcomeProjectCellModel(project: $0, delegate: self)
                }

                return (projectCellModels, modelCount)
            }
            .map { projects, modelCount -> ListViewState in
                if modelCount == 0 {
                    return .noModels(self.emptyModelConfiguration)
                } else if projects.count == 0 {
                    return .noProjects(self.emptyProjectConfiguration)
                }

                return .listProjects(projects)
            }
            .assign(to: &$listState)
    }

}

// MARK: - Public

public extension WelcomeViewModel {

    /// The title to display on the Welcome screen.
    var title: String {
        L10n.Welcome.title
    }

    /// The first subtitle to display on the Welcome screen.
    var subtitle1: String {
        L10n.Welcome.subtitle1
    }

    /// The second subtitle to display on the Welcome screen, which includes version and build numbers.
    var subtitle2: String {
        L10n.Welcome.subtitle2(Device.versionNumber, Device.buildNumber)
    }

    /// The ViewModel for the close button.
    var closeButton: IconButtonViewModel {
        .init(symbol: .xmarkCircle, hoverSymbol: .xmarkCircleFill) {
            self.onDismiss.send(())
        }
    }

    /// The ViewModel for the "New Project" button.
    var newProjectButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.loadNewProject) {
            Task { [unowned self] in
                guard let allModels = try? await persistenceService.getModels() else {
                    return
                }
                await MainActor.run {
                    self.configureProjectViewModel = .init(
                        availableModels: allModels,
                        serviceContainer: self.serviceContainer
                    )
                }
            }
        }
    }

    /// The ViewModel for the "View Source Code" button.
    var viewSourceCodeButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.viewSourceCode) {
            guard let url = URL(string: Secrets.AppInfo.sourceCodeURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    /// The ViewModel for the "Email Developer" button.
    var emailDeveloperButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.emailDeveloper) {
            let service = NSSharingService(
                named: NSSharingService.Name.composeEmail
            )
            service?.recipients = [Secrets.AppInfo.developerEmail]
            service?.perform(withItems: [""])
        }
    }

    /// The ViewModel for the "Open Model Manager" button.
    var openModelManagerButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.modelManager) {
            self.onOpen.send(.modelManager)
        }
    }

    /// The configuration for the "Delete Project" confirmation dialog.
    var deleteProjectConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.Welcome.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.Welcome.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        await self.deleteProjectAction?()
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

    /// Provides context menu configurations for a specific project cell.
    func contextMenuConfigurations(
        for cell: WelcomeProjectCellModel
    ) -> [ContextMenuConfiguration] {
        return [
            .init(text: L10n.Welcome.ProjectContextMenu.open) {
                self.open(project: cell.project)
            },
            .init(text: L10n.Welcome.ProjectContextMenu.delete) {
                self.promptDeletion(project: cell.project)
            },
            .init(text: L10n.Generics.showInFinder) {
                self.showInFinder(project: cell.project)
            }
        ]
    }

}

// MARK: - Private

private extension WelcomeViewModel {

    /// Configuration for the empty project list state.
    /// Displays a title, subtitle, and an action to create a new project.
    var emptyProjectConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Welcome.EmptyProject.title,
            subtitle: L10n.Welcome.EmptyProject.subtitle,
            icon: .booksVerticalFill,
            action: .init(
                title: L10n.Welcome.loadNewProject,
                onSelect: { [weak self] in
                    self?.newProjectButton.selected()
                }
            )
        )
    }

    /// Configuration for the empty model list state.
    /// Displays a title, subtitle, and an action to open the model manager.
    var emptyModelConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Welcome.EmptyModel.title,
            subtitle: L10n.Welcome.EmptyModel.subtitle,
            icon: .arrowDownDoc,
            action: .init(
                title: L10n.Welcome.modelManager,
                onSelect: self.openModelManagerButton.selected
            )
        )
    }

    /// Opens the specified project.
    ///
    /// - Parameter project: The `Project` instance to open.
    /// - Discussion: Dismisses the current window and triggers the opening of the project.
    func open(project: Project) {
        // Close our window
        self.onDismiss.send(())

        // Open the CreateProject window
        self.onOpen.send(
            .project(.init(project: project))
        )
    }

    /// Prompts the user to confirm deletion of a project.
    ///
    /// - Parameter project: The `Project` instance to be deleted.
    /// - Discussion: Sets up the confirmation dialog and defines the delete action.
    func promptDeletion(project: Project) {
        self.deleteProjectConfirmationDialogPresented = true
        self.deleteProjectAction = {
            await self.delete(project: project)
        }
    }

    /// Deletes the specified project.
    ///
    /// - Parameter project: The `Project` instance to delete.
    /// - Discussion: Attempts to delete the project via the persistence service. If unsuccessful,
    /// displays an alert to the user.
    func delete(project: Project) async {
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

    /// Shows the specified project's location in Finder.
    ///
    /// - Parameter project: The `Project` instance to locate in Finder.
    func showInFinder(project: Project) {
        let url = URL(filePath: project.path)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

}

// MARK: - WelcomeProjectCellViewModelDelegate

/// Conforms to `WelcomeProjectCellViewModelDelegate` to handle project-related actions from cells.
extension WelcomeViewModel: WelcomeProjectCellViewModelDelegate {

    /// Opens the specified project from a project cell.
    ///
    /// - Parameter project: The `Project` instance to open.
    public func openProject(_ project: Project) {
        self.open(project: project)
    }

}
