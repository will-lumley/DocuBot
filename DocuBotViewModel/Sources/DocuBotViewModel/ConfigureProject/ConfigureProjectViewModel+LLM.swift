//
//  ConfigureProjectViewModel+LLM.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    /// The title for the LLM section in the configuration UI.
    ///
    /// - Returns: A localized string representing the title of the LLM section.
    var llmSectionTitle: String {
        L10n.ConfigureProject.LlmSection.title
    }

    /// The subtitle for the LLM section in the configuration UI.
    ///
    /// - Returns: A localized string providing additional context for the LLM section.
    var llmSectionSubitle: String {
        L10n.ConfigureProject.LlmSection.subtitle
    }

    /// The title for the system prompt configuration option.
    ///
    /// - Returns: A localized string representing the title of the system prompt option.
    var systemPromptTitle: String {
        L10n.ConfigureProject.AdvancedSection.systemPrompt
    }

    /// The title for the seed configuration option.
    ///
    /// - Returns: A localized string representing the title of the seed option.
    var seedTitle: String {
        L10n.ConfigureProject.AdvancedSection.seed
    }

    /// The title for the top-K configuration option.
    ///
    /// - Returns: A localized string representing the title of the top-K option.
    var topKTitle: String {
        L10n.ConfigureProject.AdvancedSection.topK
    }

    /// The title for the top-P configuration option.
    ///
    /// - Returns: A localized string representing the title of the top-P option.
    var topPTitle: String {
        L10n.ConfigureProject.AdvancedSection.topP
    }

    /// The title for the temperature configuration option.
    ///
    /// - Returns: A localized string representing the title of the temperature option.
    var temperatureTitle: String {
        L10n.ConfigureProject.AdvancedSection.temperature
    }

    /// The title for the stop sequence configuration option.
    ///
    /// - Returns: A localized string representing the title of the stop sequence option.
    var stopSequenceTitle: String {
        L10n.ConfigureProject.AdvancedSection.stopSequence
    }

    /// The title for the max token count configuration option.
    ///
    /// - Returns: A localized string representing the title of the max token count option.
    var maxTokenCountTitle: String {
        L10n.ConfigureProject.AdvancedSection.maxTokenCount
    }

    /// The title for the strict mode configuration option.
    ///
    /// - Returns: A localized string representing the title of the strict mode option.
    var strictModeTitle: String {
        L10n.ConfigureProject.AdvancedSection.strictMode
    }

    /// Resets the LLM-related options to their default values.
    ///
    /// - Discussion:
    /// This method resets various advanced LLM options to predefined defaults, including:
    /// - `seed`: 1234
    /// - `topK`: 40
    /// - `topP`: 0.9
    /// - `temperature`: 0.2
    /// - `stopSequence`: Empty string
    /// - `maxTokenCount`: 1 MB (1024 * 1024)
    /// - `systemPrompt`: Default localized string
    /// - `strictMode`: `false`
    ///
    /// - Example:
    /// ```swift
    /// viewModel.resetLlmOptions()
    /// print(viewModel.temperature) // Outputs 0.2
    /// ```
    func resetLlmOptions() {
        self.seed = 1234
        self.topK = 40
        self.topP = 0.9
        self.temperature = 0.2
        self.stopSequence = "<|eot_id|>"
        self.maxTokenCount = 8192
        self.systemPrompt = L10n.ConfigureProject.AdvancedSection.SystemPrompt.default
        self.strictMode = false
    }

}
