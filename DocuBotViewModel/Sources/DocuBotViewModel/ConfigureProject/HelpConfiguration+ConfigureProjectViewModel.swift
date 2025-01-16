//
//  HelpConfiguration+ConfigureProjectViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 15/10/2024.
//

extension HelpConfiguration {

    private typealias Strings = L10n.ConfigureProject.Help

    // swiftlint:disable:next cyclomatic_complexity
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
        case .batchSize:
            self.init(
                title: Strings.BatchSize.title,
                content: Strings.BatchSize.content,
                onDismiss: onDismiss
            )
        case .contextLength:
            self.init(
                title: Strings.ContextLength.title,
                content: Strings.ContextLength.content,
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
