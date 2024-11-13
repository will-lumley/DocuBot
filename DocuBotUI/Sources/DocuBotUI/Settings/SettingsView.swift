//
//  SettingsView.swift
//  DocuBotUI
//
//  Created by William Lumley on 11/11/2024.
//

import DocuBotViewModel
import SwiftUI

public struct SettingsView: View {

    // MARK: - Properties

    @StateObject public var viewModel: SettingsViewModel

    // MARK: - Lifecycle

    public init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        TabView {
            Tab(viewModel.generalSectionTitle, systemImage: viewModel.generalSectionIcon.rawValue) {
                self.generalSettings
            }
            Tab(viewModel.embeddingSectionTitle, systemImage: viewModel.embeddingSectionIcon.rawValue) {
                self.embeddingSettings
            }
        }
        .frame(maxWidth: 500, minHeight: 150)
        .sheet(item: $viewModel.helpConfiguration) { configuration in
            HelpView(configuration: configuration)
        }
    }

    private var generalSettings: some View {
        Form {
            Section {

                // Number of Example Questions
                LabeledContent {
                    Text(viewModel.numberOfExampleQuestions.formatted())
                    Slider(
                        value: .init(
                            get: {
                                return Double(viewModel.numberOfExampleQuestions)
                            },
                            set: { newValue in
                                viewModel.numberOfExampleQuestions = Int(newValue)
                            }
                        ),
                        in: 0...10,
                        step: 1
                    )
                } label: {
                    HStack {
                        HelpButton {
                            viewModel.helpButtonSelected(
                                with: .numberOfExampleQuestions
                            )
                        }
                        Text(viewModel.numberOfExampleQuestionsTitle)
                    }
                }

                // Display Similarity Scoring
                LabeledContent {
                    Toggle(
                        isOn: $viewModel.displaySimilarityScoring,
                        label: {
                            EmptyView()
                        }
                    )
                    .toggleStyle(.switch)
                } label: {
                    HStack {
                        HelpButton {
                            viewModel.helpButtonSelected(
                                with: .displaySimilarityScoring
                            )
                        }
                        Text(viewModel.displaySimilarityScoringTitle)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }

    private var embeddingSettings: some View {
        Form {
            Section {

                // Document Prefix Count
                LabeledContent {
                    Text(viewModel.documentPrefixCount.formatted())
                    Slider(
                        value: .init(
                            get: {
                                return Double(viewModel.documentPrefixCount)
                            },
                            set: { newValue in
                                viewModel.documentPrefixCount = Int(newValue)
                            }
                        ),
                        in: 3...10,
                        step: 1
                    )
                } label: {
                    HStack {
                        HelpButton {
                            viewModel.helpButtonSelected(
                                with: .documentPrefixCount
                            )
                        }
                        Text(viewModel.documentPrefixCountTitle)
                    }
                }

                // Similarity Floor Score
                LabeledContent {
                    Text(viewModel.similarityFloorScore.formatted())
                    Slider(
                        value: $viewModel.similarityFloorScore,
                        in: 10...90,
                        step: 2
                    )
                } label: {
                    HStack {
                        HelpButton {
                            viewModel.helpButtonSelected(
                                with: .similarityFloorScore
                            )
                        }
                        Text(viewModel.similarityFloorScoreTitle)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }

}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: .mock)
}
