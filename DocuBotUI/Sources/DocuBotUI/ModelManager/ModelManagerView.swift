//
//  ModelManagerView.swift
//  DocuBotUI
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotToolbox
import DocuBotViewModel
import SwiftUI

public struct ModelManagerView: View {

    // MARK: - Types

    typealias Progress = DocuBotToolbox.Progress

    // MARK: - Properties

    @StateObject public var viewModel: ModelManagerViewModel

    public static let id = "ModelView"

    // MARK: - Lifecycle

    public init(viewModel: ModelManagerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: 0) {
            switch viewModel.listState {
            case .none:
                EmptyView()
            case .noModels(let configuration):
                Spacer()
                EmptyListView(configuration: configuration)
                Spacer()
            case .models(let models):
                List(models, selection: $viewModel.selectedModel) { model in
                    ModelCellView(viewModel: model)
                        .tag(model)
                }
                .listStyle(.inset(alternatesRowBackgrounds: true))

            case .downloading(let progress):
                self.downloadView(with: progress)
            }

            self.bottomToolbar
        }
        .navigationTitle(viewModel.windowTitle)
        .frame(width: 400, height: 450)
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
        .confirmationDialog(
            viewModel.deleteModelConfirmationDialog.title,
            isPresented: $viewModel.deleteModelConfirmationDialogPresented,
            actions: {
                ForEach(viewModel.deleteModelConfirmationDialog.buttons) { button in
                    Button(button.title, role: button.role.buttonRole, action: button.action)
                }
            }
        )
        .dialogIcon(.init(systemSymbol: .trashCircleFill))

    }

    private func downloadView(with progress: Progress) -> some View {
        VStack {
            Spacer()
            ProgressView(
                value: Float(progress.value),
                total: Float(progress.total)
            )
            .progressViewStyle(.circular)
            .controlSize(.extraLarge)
            .padding(.horizontal)

            VStack {
                Text(viewModel.progressTitle(for: progress))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom, 2)

                Text(viewModel.progressSubtitle(for: progress))
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }

            Spacer()
        }
    }

    private var bottomToolbar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color(NSColor.gridColor))

            HStack {
                Button(action: {
                    let panel = NSOpenPanel()
                    panel.canChooseDirectories    = false
                    panel.canCreateDirectories    = false
                    panel.allowsMultipleSelection = false
                    panel.canChooseFiles          = true
                    panel.allowedContentTypes     = [.gguf]
                    panel.begin { response in
                        if response == .OK {
                            viewModel.directorySelected(panel.urls.first)
                        }
                    }
                }, label: {
                    Image(systemSymbol: .plus)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: .infinity)
                })
                .frame(maxHeight: .infinity)
                .padding(.leading, 10)
                .buttonStyle(.borderless)
                .background(Color.white.opacity(0.0001))

                Button(action: viewModel.minusButtonSelected) {
                    Image(systemSymbol: .minus)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: .infinity)
                }
                .frame(maxHeight: .infinity)
                .buttonStyle(.borderless)

                Spacer()

                Button(
                    viewModel.downloadMoreButtonTitle,
                    action: viewModel.downloadMoreButtonSelected
                )
                .buttonStyle(.borderless)
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: 28, alignment: .leading)
        }
        .background(Material.bar)
    }

}
