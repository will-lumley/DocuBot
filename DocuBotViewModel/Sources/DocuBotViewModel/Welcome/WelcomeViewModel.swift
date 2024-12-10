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

    public enum OpenWindow: Hashable {
        case modelManager
        case project(ProjectViewModel.OpenWindowPackage)
    }

    public enum ListViewState {
        case none
        case listProjects([WelcomeProjectCellModel])
        case noProject(EmptyListConfiguration)
        case noModel(EmptyListConfiguration)
    }

    public typealias OnDelete = () async -> Void

    // MARK: - Properties

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// This will be called when this ViewModel wants the UI layer to close/dismiss the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// This closure will be called if a user confirms they want to delete a project
    var deleteProjectAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteProjectConfirmationDialogPresented = false

    /// The alert we'll use to communicate to the user
    @Published public var alertConfiguration: AlertConfiguration?

    /// The ViewModel for our ConfigureProject ViewModel
    @Published public var configureProjectViewModel: ConfigureProjectViewModel?

    /// The state of our ListView
    @Published public var listState: ListViewState = .none

    // MARK: - Lifecycle

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
                    return .noModel(self.emptyModelConfiguration)
                } else if projects.count == 0 {
                    return .noProject(self.emptyProjectConfiguration)
                }

                return .listProjects(projects)
            }
            .assign(to: &$listState)
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

    var viewSourceCodeButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.viewSourceCode) {
            guard let url = URL(string: Secrets.AppInfo.sourceCodeURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    var emailDeveloperButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.emailDeveloper) {
            let service = NSSharingService(
                named: NSSharingService.Name.composeEmail
            )
            service?.recipients = [Secrets.AppInfo.developerEmail]
            service?.perform(withItems: [""])
        }
    }

    var openModelManagerButton: MenuButtonViewModel {
        .init(text: L10n.Welcome.modelManager) {
            self.onOpen.send(.modelManager)
        }
    }

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

    var emptyProjectConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Welcome.EmptyProject.title,
            subtitle: L10n.Welcome.EmptyProject.subtitle,
            icon: .booksVerticalFill,
            action: .init(
                title: L10n.Welcome.loadNewProject,
                onSelect: self.newProjectButton.selected
            )
        )
    }

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
            await self.delete(project: project)
        }
    }

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
