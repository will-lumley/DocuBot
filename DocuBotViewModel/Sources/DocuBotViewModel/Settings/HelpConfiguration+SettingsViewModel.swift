//
//  HelpConfiguration+SettingsViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/11/2024.
//

/// Extends `HelpConfiguration` to support initialization from specific settings help types.
extension HelpConfiguration {

    /// A shorthand for accessing localized strings specific to settings help.
    private typealias Strings = L10n.Settings.Help

    /// Initializes a `HelpConfiguration` based on a settings help type.
    ///
    /// - Parameters:
    ///   - type: The type of help content to display, as defined in `SettingsViewModel.HelpType`.
    ///   - onDismiss: A closure to execute when the help view is dismissed.
    ///
    /// - Discussion:
    ///   This initializer maps the `HelpType` to its corresponding title and content, enabling
    ///   dynamic creation of `HelpConfiguration` instances for different settings.
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
