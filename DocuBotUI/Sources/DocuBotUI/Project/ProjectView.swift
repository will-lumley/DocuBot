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

    @State var textEditorHeight = CGFloat(20)
    @FocusState private var chatTextEditorFocused: Bool

    // MARK: - Lifecycle

    public init(viewModel: ProjectViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {

        VStack {
            Text(viewModel.queryTitle)
                .font(.title)
                .bold()

            VStack {
                ChatTextEditorView(
                    text: $viewModel.chatText,
                    height: $textEditorHeight,
                    onEnterSelected: viewModel.enterSelected
                )
                .frame(height: textEditorHeight)
                .focused($chatTextEditorFocused)
            }
            .padding(10)
            .background(Asset.chatTextView.swiftUIColor)
            .cornerRadius(35)
            .padding(.horizontal)
        }

        .toolbar {
            ToolbarButton(viewModel: viewModel.syncProjectButton)
                .keyboardShortcut("s", modifiers: [.command, .shift])
            ToolbarButton(viewModel: viewModel.openSettingsButton)
                .keyboardShortcut(",", modifiers: .command)
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
