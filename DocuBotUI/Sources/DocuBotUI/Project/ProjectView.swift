//
//  ProjectView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct ProjectView: View {

    // MARK: - Properties

    @Environment(\.openWindow) var openWindow

    @StateObject var viewModel: ProjectViewModel

    // MARK: - Lifecycle

    public init(viewModel: ProjectViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        NavigationSplitView(
            sidebar: {
                VStack {
                    if let chats = viewModel.chats {
                        if chats.isEmpty {
                            EmptyListView(configuration: viewModel.emptyChatConfiguration)
                        } else {
                            List(chats, id: \.self, selection: $viewModel.selectedChat) { cellViewModel in
                                ChatCellView(viewModel: cellViewModel)
                                    .tag(cellViewModel.id)
                                    .contextMenu {
                                        ForEach(viewModel.contextMenuConfigurations(for: cellViewModel)) { configuration in
                                            Button(configuration.text, action: configuration.onSelect)
                                        }
                                    }
                            }
                            .listStyle(.sidebar)
                        }
                    }
                }
            },
            detail: {
                if let chatViewModel = viewModel.selectedChatViewModel {
                    ChatView(viewModel: chatViewModel)
                        .id(chatViewModel.id)
                } else {
                    Text(viewModel.noChatSelectedTitle)
                        .font(.title)
                        .foregroundStyle(Color.gray)
                }
            }
        )

        .confirmationDialog(
            viewModel.deleteChatConfirmationDialog.title,
            isPresented: $viewModel.deleteChatConfirmationDialogPresented,
            actions: {
                ForEach(viewModel.deleteChatConfirmationDialog.buttons) { button in
                    Button(button.title, role: button.role.buttonRole, action: button.action)
                }
            }
        )
        .dialogIcon(.init(systemSymbol: .trashCircleFill))

        .toolbar {
            ToolbarButton(viewModel: viewModel.openSettingsButton)
            ToolbarButton(viewModel: viewModel.createChatButton)
        }

        // Listen to our OnOpen listener
        .onReceive(viewModel.onOpen) { open in
            switch open {
            case .settings(let package):
                self.openWindow(value: package)
            }
        }

        .navigationTitle(viewModel.windowTitle)
        .frame(minWidth: 650, minHeight: 550)
    }

}

// MARK: - Preview

#Preview {
    ProjectView(viewModel: .mock)
}
