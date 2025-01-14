//
//  HelpConfiguration+ConfigureProjectViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 15/10/2024.
//

extension HelpConfiguration {

    private typealias Strings = L10n.ConfigureProject.Help

    /// Initializes a `HelpConfiguration` for a specific configuration help type.
    /// 
    /// - Parameters:
    ///   - type: The specific help type associated with the configuration item.
    ///   - onDismiss: A closure that is invoked when the help dialog is dismissed.
    ///
    /// - Discussion:
    /// This initializer maps the given `HelpType` to a corresponding help title and content, using localized strings.
    /// It provides contextual help for various settings such as embedding models, similarity metrics, and
    /// tuning parameters.
    ///
    /// - Example:
    /// ```swift
    /// let help = HelpConfiguration(
    ///     type: .embeddingModel,
    ///     onDismiss: { /* Dismiss logic here*/ }
    /// )
    /// ```
    init(
        type: ConfigureProjectViewModel.HelpType,
        onDismiss: @escaping HelpConfiguration.OnDismiss
    ) {

        switch type {
        case .embeddingModel:
            self.init(
                title: Strings.EmbeddingModel.title,
                content: Strings.EmbeddingModel.content,
                onDismiss: onDismiss
            )
        case .similarityMetric:
            self.init(
                title: Strings.SimilarityMetric.title,
                content: Strings.SimilarityMetric.content,
                onDismiss: onDismiss
            )
        case .seed:
            self.init(
                title: Strings.Seed.title,
                content: Strings.Seed.content,
                onDismiss: onDismiss
            )
        case .topK:
            self.init(
                title: Strings.TopK.title,
                content: Strings.TopK.content,
                onDismiss: onDismiss
            )
        case .topP:
            self.init(
                title: Strings.TopP.title,
                content: Strings.TopP.content,
                onDismiss: onDismiss
            )
        case .temperature:
            self.init(
                title: Strings.Temperature.title,
                content: Strings.Temperature.content,
                onDismiss: onDismiss
            )
        case .stopSequence:
            self.init(
                title: Strings.StopSequence.title,
                content: Strings.StopSequence.content,
                onDismiss: onDismiss
            )
        case .maxTokenCount:
            self.init(
                title: Strings.MaxTokenCount.title,
                content: Strings.MaxTokenCount.content,
                onDismiss: onDismiss
            )
        case .strictMode:
            self.init(
                title: Strings.StrictMode.title,
                content: Strings.StrictMode.content,
                onDismiss: onDismiss
            )
        case .systemPrompt:
            self.init(
                title: Strings.SystemPrompt.title,
                content: Strings.SystemPrompt.content,
                onDismiss: onDismiss
            )
        }
    }

}
