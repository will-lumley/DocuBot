//
//  CreateProjectView.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct CreateProjectView: View {

    // MARK: - Properties

    @StateObject var viewModel: CreateProjectViewModel

    // MARK: - Lifecycle

    public init(viewModel: CreateProjectViewModel) {
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

                Section(viewModel.generalSectionTitle) {
                    LabeledContent(viewModel.projectDirectoryTitle, value: viewModel.projectDirectory)
                        .truncationMode(.middle)

                    Picker(viewModel.languageTitle, selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.availableLanguages) { language in
                            Text(language.name)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(
                    content: {
                        ForEach(viewModel.formatConfigurations) { configuration in

                            if configuration.format.isOther {
                                // This is our `other` format
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
                                .toggleStyle(.switch)
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
                    }, footer: {
                        Button {
                            viewModel.createNewFormat()
                        } label: {
                            Image(systemSymbol: .plus)
                                .padding(4)
                        }
                    }
                )
            }
            .formStyle(GroupedFormStyle())
        }
        .navigationTitle(viewModel.windowTitle)
        .frame(minWidth: 500, minHeight: 600)
    }

}

// MARK: - Preview

#Preview {
    CreateProjectView(viewModel: .mock)
}
