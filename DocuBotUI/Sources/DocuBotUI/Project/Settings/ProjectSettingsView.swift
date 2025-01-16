//
//  ProjectSettingsView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct ProjectSettingsView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: ProjectSettingsViewModel

    // MARK: - Lifecycle

    public init(viewModel: ProjectSettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: 0) {
            
            Text(viewModel.title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .top])
            
            Form {
                
                Section(viewModel.generalSectionTitle) {
                    
                    LabeledContent {
                        HStack {
                            Text(viewModel.directoryText)
                            
                            Button {
                                let panel = NSOpenPanel()
                                panel.canChooseDirectories    = true
                                panel.canCreateDirectories    = false
                                panel.allowsMultipleSelection = false
                                panel.canChooseFiles          = false
                                panel.begin { response in
                                    if response == .OK {
                                        guard let url = panel.urls.first else {
                                            return
                                        }
                                        viewModel.projectDirectory = url
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
                    
                    TextField(viewModel.projectNameTitle, text: $viewModel.projectName)
                    
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
            
            Button(viewModel.saveButtonTitle) {
                viewModel.saveButtonSelected()
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding()
            .disabled(viewModel.continueButtonEnabled == false)
        }
        .navigationTitle(viewModel.windowTitle)
        .frame(minWidth: 525, minHeight: 600)
        
        // Listen to our OnDismiss listener
        .onReceive(viewModel.onDismiss) { _ in
            self.dismiss()
        }
    }

}

// MARK: - Preview

#Preview {
    ProjectView(viewModel: .mock)
}
