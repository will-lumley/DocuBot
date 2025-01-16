//
//  ConfigureProjectViewModel+LLM.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    var llmSectionTitle: String {
        L10n.ConfigureProject.LlmSection.title
    }

    var llmSectionSubitle: String {
        L10n.ConfigureProject.LlmSection.subtitle
    }

    var systemPromptTitle: String {
        L10n.ConfigureProject.AdvancedSection.systemPrompt
    }

    var seedTitle: String {
        L10n.ConfigureProject.AdvancedSection.seed
    }

    var topKTitle: String {
        L10n.ConfigureProject.AdvancedSection.topK
    }

    var topPTitle: String {
        L10n.ConfigureProject.AdvancedSection.topP
    }

    var contextLengthTitle: String {
        L10n.ConfigureProject.AdvancedSection.contextLength
    }

    var temperatureTitle: String {
        L10n.ConfigureProject.AdvancedSection.temperature
    }

    var batchSizeTitle: String {
        L10n.ConfigureProject.AdvancedSection.batchSize
    }

    var stopSequenceTitle: String {
        L10n.ConfigureProject.AdvancedSection.stopSequence
    }

    var maxTokenCountTitle: String {
        L10n.ConfigureProject.AdvancedSection.maxTokenCount
    }

    var strictModeTitle: String {
        L10n.ConfigureProject.AdvancedSection.strictMode
    }

    func resetLlmOptions() {
        self.seed = 1234
        self.topK = 40
        self.topP = 0.9
        self.contextLength = 2048
        self.temperature = 0.2
        self.batchSize = 2048
        self.stopSequence = ""
        self.maxTokenCount = 1024*1024
        self.systemPrompt = L10n.ConfigureProject.AdvancedSection.SystemPrompt.default
        self.strictMode = false
    }

}
