//
//  ProjectView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import MarkdownUI
import SFSafeSymbols
import SwiftfulLoadingIndicators
import SwiftUI

public struct ProjectView: View {

    // MARK: - Properties

    @StateObject var viewModel: ProjectViewModel

    @Environment(\.openWindow) var openWindow

    @State var textEditorHeight = CGFloat(20)
    @State var revealSources = false

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
        .animation(.easeInOut(duration: 0.50), value: viewModel.syncStage != .none)
        .toolbar {
            ToolbarButton(viewModel: viewModel.sourcesButton)
                .keyboardShortcut("i", modifiers: [.command])
                .popover(isPresented: $viewModel.isShowingSources) {
                    if let sources = viewModel.sources {
                        SourcesView(viewModel: sources)
                    }
                }

            ToolbarButton(viewModel: viewModel.syncProjectButton)
                .keyboardShortcut("s", modifiers: [.command, .shift])

            ToolbarButton(viewModel: viewModel.projectSettingsButton)
                .keyboardShortcut(",", modifiers: .command)
        }

        .sheet(item: $viewModel.configureProjectViewModel) { viewModel in
            ConfigureProjectView(viewModel: viewModel)
        }

        .alert(item: $viewModel.alertConfiguration) { configuration in
            if let primaryAction = configuration.primaryAction {
                Alert(
                    title: Text(configuration.title),
                    message: Text(configuration.message),
                    primaryButton: .default(
                        Text(primaryAction.title),
                        action: primaryAction.onSelect
                    ),
                    secondaryButton: .cancel()
                )
            } else {
                Alert(
                    title: Text(configuration.title),
                    message: Text(configuration.message)
                )
            }
        }

        .onReceive(viewModel.triggerFolderAccessRequest) {
            let panel = NSOpenPanel()
            panel.canChooseDirectories    = true
            panel.canCreateDirectories    = false
            panel.allowsMultipleSelection = false
            panel.canChooseFiles          = false
            panel.begin { response in
                if response == .OK {
                    viewModel.directorySelected(panel.urls.first)
                }
            }
        }

        .onAppear {
            self.chatTextEditorFocused = true
        }

        .navigationTitle(viewModel.windowTitle)
        .frame(minWidth: 650, minHeight: 550)
    }

    private var mainView: some View {
        VStack {
            Text(viewModel.queryTitle)
                .font(.title)
                .bold()
                .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.questions) { viewModel in
                        ProjectQuestionView(viewModel: viewModel)
                            .frame(width: 300)
                   }
                }
                .padding(.leading)
            }

            VStack {
                ChatTextEditorView(
                    placeholder: viewModel.textEditorPlaceholder,
                    text: $viewModel.chatText,
                    height: $textEditorHeight,
                    isEnabled: viewModel.disableTextField == false,
                    onEnterSelected: viewModel.enterSelected
                )
                .frame(height: textEditorHeight)
                .focused($chatTextEditorFocused)
            }
            .padding(10)
            .background(Asset.chatTextView.swiftUIColor)
            .cornerRadius(35)
            .padding(.horizontal)

            // Add in a warning message if one is present
            if
                let alert = viewModel.alertStatus,
                let title = alert.title,
                let icon = alert.icon {
                Text("\(icon) \(title)")
                    .foregroundStyle(alert.color)
                    .font(.footnote)
                    .padding(.top, 4)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Buttons underneath the TextView
            HStack {
                // Ask Button
                Button(
                    action: viewModel.askButtonSelected,
                    label: {
                        Text("\(Image(systemSymbol: viewModel.askButtonIcon)) \(viewModel.askButtonTitle)")
                            .frame(width: 100)
                    }
                )
                .keyboardShortcut(".", modifiers: [.command])
                .padding(.horizontal)
                .controlSize(.large)
                .buttonStyle(.borderless)

                // Share Button
                ShareLink(item: viewModel.shareContent ?? "") {
                    Text("\(Image(systemSymbol: .squareAndArrowUp)) \(viewModel.shareButtonTitle)")
                        .frame(width: 100)
                }
                .disabled(viewModel.shareButtonDisabled)
                .padding(.horizontal)
                .controlSize(.large)
                .buttonStyle(.borderless)
            }
            .padding(.vertical, 4)

            switch viewModel.response {
            case .none:
                VStack {
                    Spacer()
                    LoadingIndicator(animation: .pulseOutlineRepeater)
                        .hidden()
                        .id(1)
                    Spacer()
                }
            case .response(let response):
                ScrollView {
                    Markdown(response)
                        .textSelection(.enabled)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            case .loading:
                VStack {
                    Spacer()
                    LoadingIndicator(animation: .pulseOutlineRepeater)
                        .id(2)
                    Spacer()
                }
            }
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
