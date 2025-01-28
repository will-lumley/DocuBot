//
//  CreateProjectView.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

// swiftlint:disable:next type_body_length
public struct ConfigureProjectView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.openWindow) var openWindow

    @StateObject var viewModel: ConfigureProjectViewModel

    // MARK: - Lifecycle

    public init(viewModel: ConfigureProjectViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: 0) {

            Text(viewModel.formTitle)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .top])

            Form {
                self.generalSection
                self.formatSection
                self.similaritySection
                self.llmSection
            }
            .formStyle(.grouped)

            Button(
                action: {
                    Task {
                        await viewModel.saveButtonSelected()
                    }
                },
                label: {
                    Text(viewModel.saveButtonTitle)
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(BorderedProminentButtonStyle())
            .controlSize(.extraLarge)
            .padding()
        }
        .frame(minWidth: 475, minHeight: 600)

        // Listen to our OnDismiss listener
        .onReceive(viewModel.onDismiss) { _ in
            self.dismiss()
        }

        // Listen to our OnOpen listener
        .onReceive(viewModel.onOpen) { open in
            switch open {
            case .project(let package):
                self.openWindow(value: package)
            case .none: ()
            }
        }

        .alert(item: $viewModel.alertConfiguration) { configuration in
            if let primaryAction = configuration.primaryAction {
                Alert(
                    title: Text(configuration.title),
                    message: Text(configuration.message),
                    primaryButton: .default(
                        Text(primaryAction.title),
                        action: {
                            Task { await primaryAction.onSelect() }
                        }
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

        .sheet(item: $viewModel.helpConfiguration) { configuration in
            HelpView(configuration: configuration)
        }

    }

    private var generalSection: some View {
        Section {
            // Project Directory
            LabeledContent {
                HStack {
                    Text(viewModel.projectDirectoryText)
                        .truncationMode(.middle)
                        .frame(maxWidth: 245, alignment: .trailing)
                        .lineLimit(1)

                    Button {
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
                    } label: {
                        Image(systemSymbol: .folder)
                    }
                }
                .truncationMode(.middle)
            } label: {
                Text(viewModel.projectDirectoryTitle)
            }

            // Project Name
            TextField(viewModel.projectNameTitle, text: $viewModel.projectName)

            // LLM Model
            Picker(viewModel.modelTitle, selection: $viewModel.selectedModel) {
                ForEach(viewModel.availableModels) { model in
                    Text(model.name)
                        .tag(model)
                }
            }
            .pickerStyle(.menu)

            // Project Language
            Picker(viewModel.languageTitle, selection: $viewModel.selectedLanguage) {
                ForEach(viewModel.availableLanguages) { language in
                    Text(language.name)
                }
            }
            .pickerStyle(.menu)
        } header: {
            Text(viewModel.generalSectionTitle)
                .font(.headline)
            Text(viewModel.generalSectionSubtitle)
                .font(.subheadline)
        }
    }

    private var formatSection: some View {
        Section(
            content: {
                ForEach(viewModel.formatConfigurations) { configuration in

                    if configuration.format.isOther {
                        // This is our `other` format
                        Toggle(isOn: .constant(true)) {
                            HStack {
                                TextField("", text: .init(
                                    get: {
                                        return configuration.format.otherStr ?? ""
                                    },
                                    set: { newValue in
                                        viewModel.update(formatConfiguration: configuration, otherStr: newValue)
                                    })
                                )
                                    .textFieldStyle(.roundedBorder)
                                    .disabled(configuration.isEnabled == false)
                                    .padding(.leading, -8)

                                Button {
                                    viewModel.remove(formatConfiguration: configuration)
                                } label: {
                                    Image(systemSymbol: .trash)
                                        .padding(1)
                                }
                            }
                        }
                    } else {
                        // This is our standard format
                        Toggle(isOn: .init(
                            get: {
                                return configuration.isEnabled
                            },
                            set: { newValue in
                                viewModel.set(
                                    formatConfiguration: configuration,
                                    isEnabled: newValue
                                )
                            })
                        ) {
                            Text(configuration.format.name)
                        }
                        .toggleStyle(.switch)
                    }
                }
            }, header: {
                Text(viewModel.formatSectionTitle)
                    .font(.headline)
                Text(viewModel.formatSectionSubtitle)
                    .font(.subheadline)
            }, footer: {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.createNewFormat()
                        } label: {
                            Image(systemSymbol: .plus)
                                .padding(4)
                        }
                    }
                }
            }
        )
    }

    private var similaritySection: some View {
        Section {
            // EmbeddingModel
            LabeledContent {
                Picker("", selection: $viewModel.embeddingModel) {
                    ForEach(
                        viewModel.availableEmbeddingModels, id: \.self
                    ) { model in
                        Text(model.title)
                    }
                }
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .embeddingModel)
                    }
                    Text(viewModel.embeddingModelTitle)
                }
            }

            // SimilarityMetric
            LabeledContent {
                Picker("", selection: $viewModel.similarityMetric) {
                    ForEach(viewModel.availableSimilarityMetrics, id: \.self) { model in
                        Text(model.title)
                    }
                }
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .similarityMetric)
                    }
                    Text(viewModel.similarityMetricTitle)
                }
            }

        } header: {
            Text(viewModel.similaritySectionTitle)
                .font(.headline)

            Text(viewModel.similaritySectionSubtitle)
                .font(.subheadline)

            Button(
                viewModel.resetDefaultButtonTitle,
                action: viewModel.resetSimilarityOptions
            )
                .buttonStyle(.link)
        }
    }

    private var llmSection: some View {
        Section {
            // Seed
            LabeledContent {
                TextField(
                    "",
                    value: $viewModel.seed,
                    format: .number
                )
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .seed)
                    }
                    Text(viewModel.seedTitle)
                }
            }

            // TopK
            LabeledContent {
                TextField(
                    "",
                    value: $viewModel.topK,
                    format: .number
                )
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .topK)
                    }
                    Text(viewModel.topKTitle)
                }
            }

            // TopP
            LabeledContent {
                Text(viewModel.topP.formatted())
                Slider(value: $viewModel.topP, in: 0...1, step: 0.1)
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .topP)
                    }
                    Text(viewModel.topPTitle)
                }
            }

            // Temperature
            LabeledContent {
                Text(viewModel.temperature.formatted())
                Slider(value: $viewModel.temperature, in: 0...1, step: 0.1)
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .temperature)
                    }
                    Text(viewModel.temperatureTitle)
                }
            }

            // StopSequence
            LabeledContent {
                TextField(
                    "",
                    text: Binding(
                        get: {
                            return viewModel.stopSequence ?? ""
                        },
                        set: { newValue in
                            viewModel.stopSequence = newValue
                        }
                    )
                )
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .stopSequence)
                    }
                    Text(viewModel.stopSequenceTitle)
                }
            }

            // MaxTokenCount
            LabeledContent {
                TextField(
                    "",
                    value: $viewModel.maxTokenCount,
                    format: .number
                )
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .maxTokenCount)
                    }
                    Text(viewModel.maxTokenCountTitle)
                }
            }

            // Strict Mode
            LabeledContent {
                Toggle(isOn: $viewModel.strictMode, label: {
                    EmptyView()
                })
                .toggleStyle(.checkbox)
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .strictMode)
                    }
                    Text(viewModel.strictModeTitle)
                }
            }

            // SystemPrompt
            LabeledContent {
                TextField("", text: $viewModel.systemPrompt)
            } label: {
                HStack {
                    HelpButton {
                        viewModel.helpButtonSelected(with: .systemPrompt)
                    }
                    Text(viewModel.systemPromptTitle)
                }
            }
        } header: {
            Text(viewModel.llmSectionTitle)
                .font(.headline)

            Text(viewModel.llmSectionSubitle)
                .font(.subheadline)

            Button(
                viewModel.resetDefaultButtonTitle,
                action: viewModel.resetLlmOptions
            )
                .buttonStyle(.link)
        }
    }

}

// MARK: - Preview

#Preview {
    ConfigureProjectView(viewModel: .mock)
}

public extension ConfigureProjectViewModel {

    static var mock: ConfigureProjectViewModel {
        .init(
            projectInfo: nil,
            availableModels: [.mock()],
            serviceContainer: .mock
        )
    }

}
