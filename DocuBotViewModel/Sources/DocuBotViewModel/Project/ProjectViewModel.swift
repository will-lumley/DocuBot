//
//  ProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class ProjectViewModel: DocuBotViewModel {

    // MARK: - Types

    /// This is a struct that contains the information used to open this view
    /// (ie. the `ProjectView`) itself.
    public struct OpenWindowPackage: Hashable, Codable {
         public let project: Project
    }

    public enum OpenWindow {
        case settings(ProjectSettingsViewModel.OpenWindowPackage)
    }

    public typealias OnDelete = () -> Void

    // MARK: - Properties

    @Published public var selectedChat: ChatCellViewModel?
    @Published public var selectedChatViewModel: ChatViewModel?
    @Published public var chats: [ChatCellViewModel]?

    /// This closure will be called if a user confirms they want to delete a project
    private var deleteChatAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteChatConfirmationDialogPresented = false

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    private var project: Project

    // MARK: - Lifecycle

    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // Connect our CellViewModels to our DB layer
        persistenceService.getChats(for: self.project)
            .map { $0.map { ChatCellViewModel(chat: $0, delegate: self) } }
            .replaceError(with: [])
            .assign(to: &$chats)

        // Whenever a chat is selected, create it's ChatViewModel
        self.$selectedChat
            .compactMap { $0?.chat }
            .map { [unowned self] chat in
                ChatViewModel(chat: chat, serviceContainer: self.serviceContainer)
            }
            .assign(to: &$selectedChatViewModel)
    }

}

// MARK: - Public

public extension ProjectViewModel {

    var openSettingsButton: ToolbarButtonViewModel {
        .init(symbol: .gear) {
            self.openSettings()
        }
    }

    var createChatButton: ToolbarButtonViewModel {
        .init(symbol: .squareAndPencil) {
            self.createNewChat()
        }
    }

    var syncProjectButton: ToolbarButtonViewModel {
        .init(symbol: .arrowTriangle2Circlepath) {
            self.sync()
        }
    }

    var deleteChatConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.Project.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.Project.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        self.deleteChatAction?()
                    }
                ),
                .init(
                    title: L10n.Project.Delete.Confirmation.cancelButton,
                    role: .cancel,
                    action: { }
                ),
            ]
        )
    }

    var windowTitle: String {
        self.project.name
    }

    var emptyChatConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Project.EmptyChat.title,
            subtitle: L10n.Project.EmptyChat.subtitle,
            icon: .message
        )
    }

    var noChatSelectedTitle: String {
        L10n.Project.Chat.NothingSelected.title
    }

    func openSettings() {
        Task {
            do {
                let settings = try await persistenceService.getProjectSettings(for: project)
                DispatchQueue.main.async {
                    self.onOpen.send(
                        .settings(
                            .init(project: self.project, projectSettings: settings)
                        )
                    )
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func contextMenuConfigurations(for cell: ChatCellViewModel) -> [ContextMenuConfiguration] {
        return [
            .init(text: L10n.Project.ChatContextMenu.rename) {
                
            },
            .init(text: L10n.Project.ChatContextMenu.delete) {
                self.promptDeleteChat(chat: cell.chat)
            }
        ]
    }

    func promptDeleteChat(chat: Chat) {
        self.deleteChatConfirmationDialogPresented = true
        self.deleteChatAction = {
            self.delete(chat: chat)
        }
    }

}

// MARK: - Private

private extension ProjectViewModel {

    func createNewChat() {
        let chat = Chat(
            name: L10n.Project.NewChat.defaultTitle,
            nameType: .automatic,
            projectID: self.project.id ?? -1,
            createdAt: .now
        )

        Task {
            do {
                let inserted = try await persistenceService.insert(chat: chat)

                // Select the Chat that we just created
                DispatchQueue.main.async {
                    let insertedCell = self.chats?.first { $0.chat.id == inserted.id }
                    self.selectedChat = insertedCell
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func delete(chat: Chat) {
        Task {
            do {
                _ = try await persistenceService.delete(chat: chat)
                DispatchQueue.main.async {
                    self.selectedChatViewModel = nil
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func sync() {
        Task {
            do {
                // Pull out the settings
                let settings = try await persistenceService.getProjectSettings(for: project)

                // Check if the project is dirty
                let result = try self.project.checkIfDirty(with: settings)

                switch result {
                case .clean:
                    print("Yay we're clean")
                case .dirty(newChecksum: let newChecksum):
                    print("NewChecksum: \(newChecksum)")
                    // Update the checksum
                    self.project.documentationChecksum = newChecksum
                    self.project.isDirty = true

                    // Update the DB
                    try await persistenceService.update(project: self.project)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
            
        }
    }

}

// MARK: - ChatCellViewModelDelegate

extension ProjectViewModel: ChatCellViewModelDelegate {

    public func chatRenamed(_ chat: Chat, _ newName: String) {
        Task {
            // Update the `name` and the `nameType
            let newChat = Chat(
                id: chat.id,
                name: newName,
                nameType: .userSet,
                projectID: chat.projectID,
                createdAt: chat.createdAt
            )
            try await persistenceService.update(chat: newChat)
        }
    }

}

// MARK: - Preview

public extension ProjectViewModel {

    static var mock: ProjectViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 1",
                isDirty: false,
                documentationChecksum: "123abc",
                createdAt: .now,
                updatedAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
