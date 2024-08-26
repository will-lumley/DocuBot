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

    public struct OpenWindowPackage: Hashable, Codable {
         public let project: Project
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

    private let project: Project

    // MARK: - Lifecycle

    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // Connect our CellViewModels to our DB layer
        persistenceService.getChats(for: self.project)
            .map { $0.map { ChatCellViewModel(chat: $0) } }
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

    var createChatButton: IconButtonViewModel {
        .init(symbol: .plus) {
            self.createNewChat()
        }
    }

    var deleteChatButton: IconButtonViewModel {
        .init(symbol: .minus) {
            guard let selectedChat = self.selectedChat else {
                return
            }
            self.promptDeleteChat(chat: selectedChat.chat)
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

    func contextMenuConfigurations(for cell: ChatCellViewModel) -> [ContextMenuConfiguration] {
        return [
            .init(text: L10n.Project.ChatContextMenu.rename) {
                cell.state = .rename
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
            id: nil,
            name: L10n.Project.NewChat.defaultTitle,
            nameType: .automatic,
            projectID: self.project.id ?? -1,
            createdAt: .now
        )

        Task {
            do {
                try await persistenceService.insert(chat: chat)
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

}

// MARK: - Preview

public extension ProjectViewModel {

    static var mock: ProjectViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 1",
                documentationChecksum: "123abc",
                createdAt: .now,
                updatedAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
