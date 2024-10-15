//
//  HelpConfiguration+ConfigureProjectViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 15/10/2024.
//

extension HelpConfiguration {

    typealias Strings = L10n.CreateProject.Help

    init(
        type: ConfigureProjectViewModel.HelpType,
        onDismiss: @escaping HelpConfiguration.OnDismiss
    ) {
        switch type {
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
        }
    }

}
