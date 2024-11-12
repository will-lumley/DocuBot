//
//  HelpConfiguration+SettingsViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/11/2024.
//

extension HelpConfiguration {

    private typealias Strings = L10n.Settings.Help

    init(
        type: SettingsViewModel.HelpType,
        onDismiss: @escaping HelpConfiguration.OnDismiss
    ) {
        switch type {
        case .numberOfExampleQuestions:
            self.init(
                title: Strings.NumberOfQuestions.title,
                content: Strings.NumberOfQuestions.content,
                onDismiss: onDismiss
            )
        case .displaySimilarityScoring:
            self.init(
                title: Strings.DisplaySimilarityScore.title,
                content: Strings.DisplaySimilarityScore.content,
                onDismiss: onDismiss
            )
        case .documentPrefixCount:
            self.init(
                title: Strings.DocumentPrefixCount.title,
                content: Strings.DocumentPrefixCount.content,
                onDismiss: onDismiss
            )
        case .similarityFloorScore:
            self.init(
                title: Strings.SimilarityFloorScore.title,
                content: Strings.SimilarityFloorScore.content,
                onDismiss: onDismiss
            )
        }
    }

}
