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

    @StateObject var viewModel: ProjectViewModel

    @Environment(\.openWindow) var openWindow

    @State var textEditorHeight = CGFloat(20)
    @State var isSyncing = true

    @FocusState private var chatTextEditorFocused: Bool

    // MARK: - Lifecycle

    public init(viewModel: ProjectViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {

        ZStack {
            self.mainView
            self.syncView
        }
        .animation(.easeInOut(duration: 1.0), value: isSyncing)
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

    private var mainView: some View {
        VStack {
            Text(viewModel.queryTitle)
                .font(.title)
                .bold()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.questionViewModels) { viewModel in
                        ProjectQuestionView(viewModel: viewModel)
                            .frame(width: 300)
                   }
                }
                .padding(.leading)
            }

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

            Text(viewModel.responseText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .disabled(viewModel.syncStage != nil)
        .blur(radius: (viewModel.syncStage != nil) ? 3 : 0)
    }

    private var syncView: some View {
        ZStack {
            if let syncStage = viewModel.syncStage {
                Color.black.opacity(0.85)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text(syncStage.title)
                        .font(.title)
                        .bold()

                    Text(syncStage.subtitle)
                        .font(.headline)
                        .padding(.top, 2)

                    if let progress = syncStage.progress {
                        ProgressView(
                            value: Float(progress.value),
                            total: Float(progress.total)
                        )
                            .padding()
                    }
                }
            }
        }
    }

}

// MARK: - Preview

#Preview {
    ProjectView(viewModel: .mock)
}
