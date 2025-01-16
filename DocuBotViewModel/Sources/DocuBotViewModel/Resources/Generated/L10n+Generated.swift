// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum About {
    /// View Licence
    internal static let licence = L10n.tr("Localizable", "About.licence", fallback: "View Licence")
    /// Privacy Policy
    internal static let privacyPolicy = L10n.tr("Localizable", "About.privacyPolicy", fallback: "Privacy Policy")
    /// v%@(%@)
    internal static func subtitle(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "About.subtitle", String(describing: p1), String(describing: p2), fallback: "v%@(%@)")
    }
    /// DocuBot
    internal static let title = L10n.tr("Localizable", "About.title", fallback: "DocuBot")
    internal enum ThirdPartyLibraries {
      /// DocuBot would not have been possible without these libraries:
      internal static let subtitles = L10n.tr("Localizable", "About.ThirdPartyLibraries.subtitles", fallback: "DocuBot would not have been possible without these libraries:")
      /// Acknowledgements
      internal static let title = L10n.tr("Localizable", "About.ThirdPartyLibraries.title", fallback: "Acknowledgements")
    }
  }
  internal enum ConfigureProject {
    internal enum AdvancedSection {
      /// Batch Size
      internal static let batchSize = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.batchSize", fallback: "Batch Size")
      /// Context Length
      internal static let contextLength = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.contextLength", fallback: "Context Length")
      /// Embedding Model
      internal static let embeddingModel = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.embeddingModel", fallback: "Embedding Model")
      /// Maximum Token Count
      internal static let maxTokenCount = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.maxTokenCount", fallback: "Maximum Token Count")
      /// Reset Default Values
      internal static let resetDefaults = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.resetDefaults", fallback: "Reset Default Values")
      /// Seed
      internal static let seed = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.seed", fallback: "Seed")
      /// Similarity Metric
      internal static let similarityMetric = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.similarityMetric", fallback: "Similarity Metric")
      /// Stop Sequence
      internal static let stopSequence = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.stopSequence", fallback: "Stop Sequence")
      /// Strict Mode
      internal static let strictMode = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.strictMode", fallback: "Strict Mode")
      /// System Prompt
      internal static let systemPrompt = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.systemPrompt", fallback: "System Prompt")
      /// Temperature
      internal static let temperature = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.temperature", fallback: "Temperature")
      /// Top K
      internal static let topK = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.topK", fallback: "Top K")
      /// Top P
      internal static let topP = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.topP", fallback: "Top P")
      internal enum SystemPrompt {
        /// You are a helpful assistant named DocuBot. DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries. You have been trained on a directory that contains the relevant documentation. You are expected to answer the user's questions to their code base. If you don't know the answer, simply say that. Avoid long paragraphs and break them up with newlines if need be. All responses you generate should be formatted in Markdown. Use `#` for headers, `*` or `-` for bullet points, and backticks (`) for inline code and code blocks. Include links using [text](URL) format.
        internal static let `default` = L10n.tr("Localizable", "ConfigureProject.AdvancedSection.SystemPrompt.default", fallback: "You are a helpful assistant named DocuBot. DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer documentation queries. You have been trained on a directory that contains the relevant documentation. You are expected to answer the user's questions to their code base. If you don't know the answer, simply say that. Avoid long paragraphs and break them up with newlines if need be. All responses you generate should be formatted in Markdown. Use `#` for headers, `*` or `-` for bullet points, and backticks (`) for inline code and code blocks. Include links using [text](URL) format.")
      }
    }
    internal enum Creating {
      /// Create Project
      internal static let createButton = L10n.tr("Localizable", "ConfigureProject.Creating.createButton", fallback: "Create Project")
      /// Create your new project
      internal static let formTitle = L10n.tr("Localizable", "ConfigureProject.Creating.formTitle", fallback: "Create your new project")
    }
    internal enum Editing {
      /// Update Project
      internal static let createButton = L10n.tr("Localizable", "ConfigureProject.Editing.createButton", fallback: "Update Project")
      /// Update your project
      internal static let formTitle = L10n.tr("Localizable", "ConfigureProject.Editing.formTitle", fallback: "Update your project")
    }
    internal enum FormatSection {
      /// We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later.
      internal static let subtitle = L10n.tr("Localizable", "ConfigureProject.FormatSection.subtitle", fallback: "We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later.")
      /// What format is your documentation in?
      internal static let title = L10n.tr("Localizable", "ConfigureProject.FormatSection.title", fallback: "What format is your documentation in?")
      internal enum Format {
        /// Add Custom Format
        internal static let addFormatButton = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.addFormatButton", fallback: "Add Custom Format")
        /// .html
        internal static let html = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.html", fallback: ".html")
        /// .md
        internal static let md = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.md", fallback: ".md")
        /// Other
        internal static let other = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.other", fallback: "Other")
        /// .rtf
        internal static let rtf = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.rtf", fallback: ".rtf")
        /// .txt
        internal static let txt = L10n.tr("Localizable", "ConfigureProject.FormatSection.Format.txt", fallback: ".txt")
      }
    }
    internal enum GeneralSection {
      /// Tell us a bit about your project.
      internal static let subtitle = L10n.tr("Localizable", "ConfigureProject.GeneralSection.subtitle", fallback: "Tell us a bit about your project.")
      /// General
      internal static let title = L10n.tr("Localizable", "ConfigureProject.GeneralSection.title", fallback: "General")
      internal enum Directory {
        /// Select a Directory
        internal static let select = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Directory.select", fallback: "Select a Directory")
        /// Project Directory
        internal static let title = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Directory.title", fallback: "Project Directory")
      }
      internal enum Language {
        /// English
        internal static let english = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Language.english", fallback: "English")
        /// Language
        internal static let title = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Language.title", fallback: "Language")
      }
      internal enum Model {
        /// Select a Model
        internal static let select = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Model.select", fallback: "Select a Model")
        /// LLM Model
        internal static let title = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Model.title", fallback: "LLM Model")
      }
      internal enum Name {
        /// Project Name
        internal static let title = L10n.tr("Localizable", "ConfigureProject.GeneralSection.Name.title", fallback: "Project Name")
      }
    }
    internal enum Help {
      internal enum BatchSize {
        /// This parameter defines the number of tokens processed in one batch during the generation or training phase.
        /// 
        /// A batch size of 2048 means the model processes up to 2048 tokens at once. This can affect both the memory usage and performance during generation.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.BatchSize.content", fallback: "This parameter defines the number of tokens processed in one batch during the generation or training phase.\n\nA batch size of 2048 means the model processes up to 2048 tokens at once. This can affect both the memory usage and performance during generation.")
        /// What does batch size do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.BatchSize.title", fallback: "What does batch size do?")
      }
      internal enum ContextLength {
        /// The context length defines how many tokens the model can consider at once when generating text.
        /// 
        /// By default, the model can use up to 2048 tokens of context, allowing it to maintain and use information over a relatively long span of generated text.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.ContextLength.content", fallback: "The context length defines how many tokens the model can consider at once when generating text.\n\nBy default, the model can use up to 2048 tokens of context, allowing it to maintain and use information over a relatively long span of generated text.")
        /// What does context length do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.ContextLength.title", fallback: "What does context length do?")
      }
      internal enum EmbeddingModel {
        /// An embedding model transforms input data (like text) into numerical vectors that represent the semantic meaning of the data.
        /// 
        /// These embeddings are used to measure relationships and similarities between different pieces of content, allowing the model to understand the context and meaning of the input.
        /// 
        /// DistilBERT is a small version of the BERT model that has been fine tuned for question & answers.
        /// MiniLM All, is a smaller model, but it is much faster.
        /// Multi-QA MiniLM is a small & fast model that has been fine tuned for question & answering.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.EmbeddingModel.content", fallback: "An embedding model transforms input data (like text) into numerical vectors that represent the semantic meaning of the data.\n\nThese embeddings are used to measure relationships and similarities between different pieces of content, allowing the model to understand the context and meaning of the input.\n\nDistilBERT is a small version of the BERT model that has been fine tuned for question & answers.\nMiniLM All, is a smaller model, but it is much faster.\nMulti-QA MiniLM is a small & fast model that has been fine tuned for question & answering.")
        /// What does the embedding model do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.EmbeddingModel.title", fallback: "What does the embedding model do?")
      }
      internal enum MaxTokenCount {
        /// This sets the maximum number of tokens the model is allowed to generate.
        /// 
        /// Even if the model hasn’t hit a stopping condition (such as a stop sequence), it will stop once it generates the specified amount of tokens.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.MaxTokenCount.content", fallback: "This sets the maximum number of tokens the model is allowed to generate.\n\nEven if the model hasn’t hit a stopping condition (such as a stop sequence), it will stop once it generates the specified amount of tokens.")
        /// What does max token count do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.MaxTokenCount.title", fallback: "What does max token count do?")
      }
      internal enum Seed {
        /// The seed value is used to initialise the random number generator, which influences how the model generates text.
        /// 
        /// By setting a seed, you ensure that the generation process is deterministic - running the same input with the same seed will result in the same output. This is useful for reproducibility.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.Seed.content", fallback: "The seed value is used to initialise the random number generator, which influences how the model generates text.\n\nBy setting a seed, you ensure that the generation process is deterministic - running the same input with the same seed will result in the same output. This is useful for reproducibility.")
        /// What does seed do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.Seed.title", fallback: "What does seed do?")
      }
      internal enum SimilarityMetric {
        /// A similarity metric is a mathematical function used to compare the embeddings of two pieces of data.
        /// 
        /// It helps quantify how closely related two inputs are. Common similarity metrics include cosine similarity, which measures the angle between two vectors, and Euclidean distance, which measures the straight-line distance between them.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.SimilarityMetric.content", fallback: "A similarity metric is a mathematical function used to compare the embeddings of two pieces of data.\n\nIt helps quantify how closely related two inputs are. Common similarity metrics include cosine similarity, which measures the angle between two vectors, and Euclidean distance, which measures the straight-line distance between them.")
        /// What does the similarity metric do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.SimilarityMetric.title", fallback: "What does the similarity metric do?")
      }
      internal enum StopSequence {
        /// If a stop sequence is specified, the generation will stop when the model generates the provided string sequence.
        /// 
        /// This is useful when you want to halt the model’s output after a certain phrase or token appears. If set to blank, the model will continue generating text until it reaches the maximum token limit or another stopping condition.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.StopSequence.content", fallback: "If a stop sequence is specified, the generation will stop when the model generates the provided string sequence.\n\nThis is useful when you want to halt the model’s output after a certain phrase or token appears. If set to blank, the model will continue generating text until it reaches the maximum token limit or another stopping condition.")
        /// What does stop sequence do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.StopSequence.title", fallback: "What does stop sequence do?")
      }
      internal enum StrictMode {
        /// Strict Mode ensures that DocuBot returns only the content from the documentation without additional commentary or elaboration from the AI model.
        /// 
        /// In this mode, the LLM will be disabled, and the response will strictly repeat excerpts from the provided documentation.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.StrictMode.content", fallback: "Strict Mode ensures that DocuBot returns only the content from the documentation without additional commentary or elaboration from the AI model.\n\nIn this mode, the LLM will be disabled, and the response will strictly repeat excerpts from the provided documentation.")
        /// What does strict mode do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.StrictMode.title", fallback: "What does strict mode do?")
      }
      internal enum SystemPrompt {
        /// A system message provides background context or guidance to the model to help it generate appropriate responses.
        /// 
        /// It defines the model’s role, tone, and behavior. For example, a system message might instruct the model to act as a helpful assistant, limiting its answers to a specific knowledge domain.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.SystemPrompt.content", fallback: "A system message provides background context or guidance to the model to help it generate appropriate responses.\n\nIt defines the model’s role, tone, and behavior. For example, a system message might instruct the model to act as a helpful assistant, limiting its answers to a specific knowledge domain.")
        /// What does system prompt do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.SystemPrompt.title", fallback: "What does system prompt do?")
      }
      internal enum Temperature {
        /// Temperature controls the "creativity" or randomness of the output.
        /// 
        /// A lower temperature (e.g., 0.2) makes the model more conservative and focused on high-probability tokens, leading to more predictable and repetitive outputs. A higher temperature makes the model more creative and prone to selecting less likely tokens.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.Temperature.content", fallback: "Temperature controls the \"creativity\" or randomness of the output.\n\nA lower temperature (e.g., 0.2) makes the model more conservative and focused on high-probability tokens, leading to more predictable and repetitive outputs. A higher temperature makes the model more creative and prone to selecting less likely tokens.")
        /// What does temperature do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.Temperature.title", fallback: "What does temperature do?")
      }
      internal enum TopK {
        /// Top-K sampling limits the model to choosing from only the top K most likely next tokens (words, subwords, etc.).
        /// 
        /// By default, K is set to 40, meaning the model will only consider the 40 most probable next tokens, adding an element of randomness while ensuring more likely tokens are preferred.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.TopK.content", fallback: "Top-K sampling limits the model to choosing from only the top K most likely next tokens (words, subwords, etc.).\n\nBy default, K is set to 40, meaning the model will only consider the 40 most probable next tokens, adding an element of randomness while ensuring more likely tokens are preferred.")
        /// What does top-k do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.TopK.title", fallback: "What does top-k do?")
      }
      internal enum TopP {
        /// Top-P sampling (also known as nucleus sampling) dynamically selects the smallest possible set of tokens whose cumulative probability exceeds P.
        /// 
        /// By default, P is 0.9, so the model will sample from the top 90 percent of the probability mass, making it more flexible than top-K and helping balance between randomness and determinism in the generation.
        internal static let content = L10n.tr("Localizable", "ConfigureProject.Help.TopP.content", fallback: "Top-P sampling (also known as nucleus sampling) dynamically selects the smallest possible set of tokens whose cumulative probability exceeds P.\n\nBy default, P is 0.9, so the model will sample from the top 90 percent of the probability mass, making it more flexible than top-K and helping balance between randomness and determinism in the generation.")
        /// What does top-p do?
        internal static let title = L10n.tr("Localizable", "ConfigureProject.Help.TopP.title", fallback: "What does top-p do?")
      }
    }
    internal enum LlmSection {
      /// Adjust advanced settings for the LLM, including model parameters and behavior to optimise performance and responsiveness. Adjust them only if you need something specific.
      internal static let subtitle = L10n.tr("Localizable", "ConfigureProject.LlmSection.subtitle", fallback: "Adjust advanced settings for the LLM, including model parameters and behavior to optimise performance and responsiveness. Adjust them only if you need something specific.")
      /// LLM Configuration
      internal static let title = L10n.tr("Localizable", "ConfigureProject.LlmSection.title", fallback: "LLM Configuration")
    }
    internal enum Resync {
      /// Save Settings
      internal static let saveButton = L10n.tr("Localizable", "ConfigureProject.Resync.saveButton", fallback: "Save Settings")
      /// Re-Sync Will Be Needed
      internal static let title = L10n.tr("Localizable", "ConfigureProject.Resync.title", fallback: "Re-Sync Will Be Needed")
      internal enum Directory {
        /// Changing the directorywill require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.
        internal static let message = L10n.tr("Localizable", "ConfigureProject.Resync.Directory.message", fallback: "Changing the directorywill require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.")
      }
      internal enum Format {
        /// Changing the formats of the documentation that DocuBot has access to will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.
        internal static let message = L10n.tr("Localizable", "ConfigureProject.Resync.Format.message", fallback: "Changing the formats of the documentation that DocuBot has access to will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.")
      }
      internal enum Metric {
        /// Changing the similarity metric will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.
        internal static let message = L10n.tr("Localizable", "ConfigureProject.Resync.Metric.message", fallback: "Changing the similarity metric will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.")
      }
      internal enum Model {
        /// Changing the similarity model will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.
        internal static let message = L10n.tr("Localizable", "ConfigureProject.Resync.Model.message", fallback: "Changing the similarity model will require a full re-sync to reflect the updates. You'll be prompted to initiate this after saving the settings.")
      }
    }
    internal enum SimilaritySection {
      /// These options determine how the similarity between query inputs and documentation is calculated, affecting the accuracy of results. Adjust them only if you need something specific.
      /// Changing these will require a full resync of your project.
      internal static let subtitle = L10n.tr("Localizable", "ConfigureProject.SimilaritySection.subtitle", fallback: "These options determine how the similarity between query inputs and documentation is calculated, affecting the accuracy of results. Adjust them only if you need something specific.\nChanging these will require a full resync of your project.")
      /// Similarity Metric Configuration
      internal static let title = L10n.tr("Localizable", "ConfigureProject.SimilaritySection.title", fallback: "Similarity Metric Configuration")
    }
  }
  internal enum EmbeddingModel {
    internal enum Distilbert {
      /// Distilbert
      internal static let title = L10n.tr("Localizable", "EmbeddingModel.Distilbert.title", fallback: "Distilbert")
    }
    internal enum MiniLme {
      /// Mini LME
      internal static let title = L10n.tr("Localizable", "EmbeddingModel.MiniLme.title", fallback: "Mini LME")
    }
    internal enum MultiQaMiniLme {
      /// Multi QA Mini LME
      internal static let title = L10n.tr("Localizable", "EmbeddingModel.MultiQaMiniLme.title", fallback: "Multi QA Mini LME")
    }
  }
  internal enum Error {
    internal enum ConfigureProject {
      internal enum Creating {
        internal enum FailedToCreate {
          /// Failed to Create Project
          internal static let title = L10n.tr("Localizable", "Error.ConfigureProject.Creating.FailedToCreate.title", fallback: "Failed to Create Project")
        }
      }
      internal enum Editing {
        internal enum FailedToCreate {
          /// Failed to Update Project
          internal static let title = L10n.tr("Localizable", "Error.ConfigureProject.Editing.FailedToCreate.title", fallback: "Failed to Update Project")
        }
      }
      internal enum FormValidation {
        /// Please ensure that the Top-P value is within the range of 0.0 and 1.0.
        internal static let invalidTopP = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.invalidTopP", fallback: "Please ensure that the Top-P value is within the range of 0.0 and 1.0.")
        /// Please ensure that a valid batch size is provided.
        internal static let missingBatchSize = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingBatchSize", fallback: "Please ensure that a valid batch size is provided.")
        /// Please ensure that a valid context length is provided.
        internal static let missingContextLength = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingContextLength", fallback: "Please ensure that a valid context length is provided.")
        /// Please ensure that a project directory has been selected.
        internal static let missingDirectory = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingDirectory", fallback: "Please ensure that a project directory has been selected.")
        /// No secure directory data is avaiable to DocuBot.
        internal static let missingDirectoryData = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingDirectoryData", fallback: "No secure directory data is avaiable to DocuBot.")
        /// Please ensure that at least one format has been enabled.
        internal static let missingFormat = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingFormat", fallback: "Please ensure that at least one format has been enabled.")
        /// Please ensure that a valid maximum token count is provided.
        internal static let missingMaxTokenCount = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingMaxTokenCount", fallback: "Please ensure that a valid maximum token count is provided.")
        /// Please ensure that a model has been selected.
        internal static let missingModel = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingModel", fallback: "Please ensure that a model has been selected.")
        /// Please ensure that a project name has been provided.
        internal static let missingName = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingName", fallback: "Please ensure that a project name has been provided.")
        /// Please ensure that a valid seed value is provided.
        internal static let missingSeed = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingSeed", fallback: "Please ensure that a valid seed value is provided.")
        /// Please ensure that a valid system prompt is provided.
        internal static let missingSystemPrompt = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingSystemPrompt", fallback: "Please ensure that a valid system prompt is provided.")
        /// Please ensure that a valid Top-K value is provided.
        internal static let missingTopK = L10n.tr("Localizable", "Error.ConfigureProject.FormValidation.missingTopK", fallback: "Please ensure that a valid Top-K value is provided.")
      }
    }
    internal enum ModelManager {
      internal enum DeleteModel {
        /// Failed to delete model
        internal static let title = L10n.tr("Localizable", "Error.ModelManager.DeleteModel.title", fallback: "Failed to delete model")
      }
      internal enum ModelDownloadError {
        /// Failed to create the directory that DocuBot uses to store models wihtin.
        internal static let failedToCreateSubdirectory = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.failedToCreateSubdirectory", fallback: "Failed to create the directory that DocuBot uses to store models wihtin.")
        /// Failed to get the relevant metadata from the model.
        internal static let failedToGetFileSize = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.failedToGetFileSize", fallback: "Failed to get the relevant metadata from the model.")
        /// Failed to copy the model to DocuBot's local directory.
        internal static let failedToMoveToAppSupport = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.failedToMoveToAppSupport", fallback: "Failed to copy the model to DocuBot's local directory.")
        /// DocuBot cannot find the data of the downloaded file.
        internal static let missingDownloadFile = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.missingDownloadFile", fallback: "DocuBot cannot find the data of the downloaded file.")
        /// Failed to find the Application Support directory.
        internal static let noAppSupportDirectory = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.noAppSupportDirectory", fallback: "Failed to find the Application Support directory.")
        /// Failed to download and install model
        internal static let title = L10n.tr("Localizable", "Error.ModelManager.ModelDownloadError.title", fallback: "Failed to download and install model")
      }
      internal enum ModelError {
        /// Failed to delete model.
        internal static let failedToDelete = L10n.tr("Localizable", "Error.ModelManager.ModelError.failedToDelete", fallback: "Failed to delete model.")
        /// No directory selected.
        internal static let noDirectory = L10n.tr("Localizable", "Error.ModelManager.ModelError.noDirectory", fallback: "No directory selected.")
        /// Failed to get file access
        internal static let title = L10n.tr("Localizable", "Error.ModelManager.ModelError.title", fallback: "Failed to get file access")
      }
      internal enum ModelImportError {
        /// Failed to import model
        internal static let title = L10n.tr("Localizable", "Error.ModelManager.ModelImportError.title", fallback: "Failed to import model")
      }
    }
    internal enum Project {
      internal enum FailedToCheckProject {
        /// Failed to Check Project's Documents
        internal static let title = L10n.tr("Localizable", "Error.Project.FailedToCheckProject.title", fallback: "Failed to Check Project's Documents")
      }
      internal enum FailedToExtractSettings {
        /// Failed to get Project Settings
        internal static let title = L10n.tr("Localizable", "Error.Project.FailedToExtractSettings.title", fallback: "Failed to get Project Settings")
      }
      internal enum FailedToSync {
        /// Failed to Sync
        internal static let title = L10n.tr("Localizable", "Error.Project.FailedToSync.title", fallback: "Failed to Sync")
      }
      internal enum GptTalk {
        /// Failed to get communicate with the LLM
        internal static let title = L10n.tr("Localizable", "Error.Project.GptTalk.title", fallback: "Failed to get communicate with the LLM")
      }
      internal enum StaleBookmark {
        /// Select Folder
        internal static let action = L10n.tr("Localizable", "Error.Project.StaleBookmark.action", fallback: "Select Folder")
        /// It looks like the file's location has changed or is no longer accessible. Please select the file again to continue.
        internal static let message = L10n.tr("Localizable", "Error.Project.StaleBookmark.message", fallback: "It looks like the file's location has changed or is no longer accessible. Please select the file again to continue.")
        /// Folder Access Issue
        internal static let title = L10n.tr("Localizable", "Error.Project.StaleBookmark.title", fallback: "Folder Access Issue")
      }
      internal enum UpdateBookmark {
        /// Failed to get folder access
        internal static let title = L10n.tr("Localizable", "Error.Project.UpdateBookmark.title", fallback: "Failed to get folder access")
      }
    }
    internal enum Welcome {
      internal enum FailedToDelete {
        /// DocuBot failed to delete the project. Please try again.
        internal static let message = L10n.tr("Localizable", "Error.Welcome.FailedToDelete.message", fallback: "DocuBot failed to delete the project. Please try again.")
        /// Failed to Delete Project
        internal static let title = L10n.tr("Localizable", "Error.Welcome.FailedToDelete.title", fallback: "Failed to Delete Project")
      }
    }
  }
  internal enum Generics {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Generics.cancel", fallback: "Cancel")
    /// Show in Finder
    internal static let showInFinder = L10n.tr("Localizable", "Generics.showInFinder", fallback: "Show in Finder")
  }
  internal enum ModelManager {
    /// Model Manager
    internal static let windowTitle = L10n.tr("Localizable", "ModelManager.windowTitle", fallback: "Model Manager")
    internal enum Cell {
      /// %@ GB
      internal static func subtitle(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ModelManager.Cell.subtitle", String(describing: p1), fallback: "%@ GB")
      }
    }
    internal enum Delete {
      internal enum Confirmation {
        /// Cancel
        internal static let cancelButton = L10n.tr("Localizable", "ModelManager.Delete.Confirmation.cancelButton", fallback: "Cancel")
        /// Delete this Model
        internal static let deleteButton = L10n.tr("Localizable", "ModelManager.Delete.Confirmation.deleteButton", fallback: "Delete this Model")
        /// Are you sure you want to delete this model?
        internal static let title = L10n.tr("Localizable", "ModelManager.Delete.Confirmation.title", fallback: "Are you sure you want to delete this model?")
      }
    }
    internal enum DownloadMoreButton {
      /// Find New Models
      internal static let title = L10n.tr("Localizable", "ModelManager.DownloadMoreButton.title", fallback: "Find New Models")
    }
    internal enum DownloadProgress {
      /// %@GB of %@GB downloaded
      internal static func subtitle(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "ModelManager.DownloadProgress.subtitle", String(describing: p1), String(describing: p2), fallback: "%@GB of %@GB downloaded")
      }
      /// Model download is %@%% complete
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ModelManager.DownloadProgress.title", String(describing: p1), fallback: "Model download is %@%% complete")
      }
    }
    internal enum EmptyList {
      /// DocuBot runs AI models locally on your Mac, ensuring maximum privacy and security. Chat with a variety of AI models, each offering unique expertise based on its training data and knowledge base.
      /// 
      /// Import a model from your device using the + button, or download a recommended one using the button below.
      internal static let subtitle = L10n.tr("Localizable", "ModelManager.EmptyList.subtitle", fallback: "DocuBot runs AI models locally on your Mac, ensuring maximum privacy and security. Chat with a variety of AI models, each offering unique expertise based on its training data and knowledge base.\n\nImport a model from your device using the + button, or download a recommended one using the button below.")
      /// No models imported yet
      internal static let title = L10n.tr("Localizable", "ModelManager.EmptyList.title", fallback: "No models imported yet")
      internal enum Action {
        /// ~3.74 GB
        internal static let secondaryTitle = L10n.tr("Localizable", "ModelManager.EmptyList.Action.secondaryTitle", fallback: "~3.74 GB")
        /// Download Default Model
        internal static let title = L10n.tr("Localizable", "ModelManager.EmptyList.Action.title", fallback: "Download Default Model")
      }
    }
  }
  internal enum Project {
    /// Write your question here...
    internal static let placeholder = L10n.tr("Localizable", "Project.placeholder", fallback: "Write your question here...")
    /// Ask any question about your project.
    internal static let queryTitle = L10n.tr("Localizable", "Project.queryTitle", fallback: "Ask any question about your project.")
    internal enum Error {
      /// This project has not been synced yet. Please perform an initial sync to load and index the project's documentation.
      internal static let firstSync = L10n.tr("Localizable", "Project.Error.firstSync", fallback: "This project has not been synced yet. Please perform an initial sync to load and index the project's documentation.")
    }
    internal enum LlmExampleQuestionPrompt {
      /// Here is an excerpt from a file.
      /// 
      /// %@
      /// 
      /// Based on this content, generate a question that would help someone engage with or better understand the key concepts discussed. Write only the question, nothing else.
      internal static func prompt(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Project.LlmExampleQuestionPrompt.prompt", String(describing: p1), fallback: "Here is an excerpt from a file.\n\n%@\n\nBased on this content, generate a question that would help someone engage with or better understand the key concepts discussed. Write only the question, nothing else.")
      }
      /// You are a formal assistant whose role is to help generate content-specific questions based on provided excerpts. Your primary directive is to **strictly follow the given instructions** without adding any extra commentary, conversational language, or filler.
      /// When asked to generate a question, **only write the question itself** in a clear and concise format. Avoid adding any greetings, explanations, or follow-up statements. Your output should consist solely of the question that addresses the key concepts of the provided content.
      /// Remember: do not include phrases like "I hope this helps" or "Let me know if you need anything else." Focus only on delivering the requested content without deviation.
      internal static let systemMessage = L10n.tr("Localizable", "Project.LlmExampleQuestionPrompt.systemMessage", fallback: "You are a formal assistant whose role is to help generate content-specific questions based on provided excerpts. Your primary directive is to **strictly follow the given instructions** without adding any extra commentary, conversational language, or filler.\nWhen asked to generate a question, **only write the question itself** in a clear and concise format. Avoid adding any greetings, explanations, or follow-up statements. Your output should consist solely of the question that addresses the key concepts of the provided content.\nRemember: do not include phrases like \"I hope this helps\" or \"Let me know if you need anything else.\" Focus only on delivering the requested content without deviation.")
    }
    internal enum LlmQueryPrompt {
      /// Here is some information.
      /// %@
      /// %@
      internal static func template(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Project.LlmQueryPrompt.template", String(describing: p1), String(describing: p2), fallback: "Here is some information.\n%@\n%@")
      }
    }
    internal enum QueryButton {
      internal enum Ask {
        /// Ask Question
        internal static let title = L10n.tr("Localizable", "Project.QueryButton.Ask.title", fallback: "Ask Question")
      }
      internal enum Cancel {
        /// Cancel
        internal static let title = L10n.tr("Localizable", "Project.QueryButton.Cancel.title", fallback: "Cancel")
      }
    }
    internal enum ShareButton {
      /// Share
      internal static let title = L10n.tr("Localizable", "Project.ShareButton.title", fallback: "Share")
    }
    internal enum StrictMode {
      /// Here's some excerpts from your documentation based on your query.
      /// 
      /// 
      internal static let responseTemplate = L10n.tr("Localizable", "Project.StrictMode.responseTemplate", fallback: "Here's some excerpts from your documentation based on your query.\n\n")
      /// # %@
      /// 
      /// %@
      /// 
      /// 
      internal static func sourceTemplate(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Project.StrictMode.sourceTemplate", String(describing: p1), String(describing: p2), fallback: "# %@\n\n%@\n\n")
      }
    }
    internal enum SyncStage {
      internal enum BuildingQuestions {
        /// We've made %@ out of %@ questions. Not long now!
        internal static func subtitle(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "Project.SyncStage.BuildingQuestions.subtitle", String(describing: p1), String(describing: p2), fallback: "We've made %@ out of %@ questions. Not long now!")
        }
        /// Building some example questions for you 💡
        internal static let title = L10n.tr("Localizable", "Project.SyncStage.BuildingQuestions.title", fallback: "Building some example questions for you 💡")
      }
      internal enum ExtractingDocuments {
        /// This shouldn't take too long.
        internal static let subtitle = L10n.tr("Localizable", "Project.SyncStage.ExtractingDocuments.subtitle", fallback: "This shouldn't take too long.")
        /// Reading documents from disk
        internal static let title = L10n.tr("Localizable", "Project.SyncStage.ExtractingDocuments.title", fallback: "Reading documents from disk")
      }
      internal enum TrainingDocuments {
        /// We've gone through %@ out of %@ documents. Sit tight!
        internal static func subtitle(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "Project.SyncStage.TrainingDocuments.subtitle", String(describing: p1), String(describing: p2), fallback: "We've gone through %@ out of %@ documents. Sit tight!")
        }
        /// DocuBot is studying %@ 🙇‍♂️
        internal static func title(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Project.SyncStage.TrainingDocuments.title", String(describing: p1), fallback: "DocuBot is studying %@ 🙇‍♂️")
        }
      }
    }
    internal enum Toolbar {
      /// Settings
      internal static let settings = L10n.tr("Localizable", "Project.Toolbar.settings", fallback: "Settings")
      /// Sources
      internal static let sources = L10n.tr("Localizable", "Project.Toolbar.sources", fallback: "Sources")
      /// Sync
      internal static let sync = L10n.tr("Localizable", "Project.Toolbar.sync", fallback: "Sync")
    }
    internal enum Warning {
      /// The project's location has been changed. A sync is required to ensure the latest changes are reflected.
      internal static let directoryChanged = L10n.tr("Localizable", "Project.Warning.directoryChanged", fallback: "The project's location has been changed. A sync is required to ensure the latest changes are reflected.")
      /// The project's specified documentation format has been changed. A sync is required to ensure the latest changes are reflected.
      internal static let formatsChanged = L10n.tr("Localizable", "Project.Warning.formatsChanged", fallback: "The project's specified documentation format has been changed. A sync is required to ensure the latest changes are reflected.")
      /// The project's documentation has changed on disk. A sync is required to ensure the latest changes are reflected.
      internal static let isDirty = L10n.tr("Localizable", "Project.Warning.isDirty", fallback: "The project's documentation has changed on disk. A sync is required to ensure the latest changes are reflected.")
      /// The project's similarity metric has been changed. A sync is required to ensure the latest changes are reflected.
      internal static let metricChanged = L10n.tr("Localizable", "Project.Warning.metricChanged", fallback: "The project's similarity metric has been changed. A sync is required to ensure the latest changes are reflected.")
      /// The project's embedding model has been changed. A sync is required to ensure the latest changes are reflected.
      internal static let modelChanged = L10n.tr("Localizable", "Project.Warning.modelChanged", fallback: "The project's embedding model has been changed. A sync is required to ensure the latest changes are reflected.")
    }
  }
  internal enum ProjectSettings {
    /// Save Settings
    internal static let saveButton = L10n.tr("Localizable", "ProjectSettings.saveButton", fallback: "Save Settings")
    /// Project Settings
    internal static let windowTitle = L10n.tr("Localizable", "ProjectSettings.windowTitle", fallback: "Project Settings")
  }
  internal enum Settings {
    internal enum DisplaySimilarityScore {
      /// Display Similarity Score
      internal static let title = L10n.tr("Localizable", "Settings.DisplaySimilarityScore.title", fallback: "Display Similarity Score")
    }
    internal enum DocumentPrefixCount {
      /// Document Prefix Count
      internal static let title = L10n.tr("Localizable", "Settings.DocumentPrefixCount.title", fallback: "Document Prefix Count")
    }
    internal enum Help {
      internal enum DisplaySimilarityScore {
        /// Within the sources list that is available after a query is performed, you can opt in to have the similarity score for that document represented in a pie chart.
        /// 
        /// The similarity score represents how closely related DocuBot predicts your query is to each document. A higher score indicates a stronger match, helping you quickly identify the most relevant sources for your search.
        internal static let content = L10n.tr("Localizable", "Settings.Help.DisplaySimilarityScore.content", fallback: "Within the sources list that is available after a query is performed, you can opt in to have the similarity score for that document represented in a pie chart.\n\nThe similarity score represents how closely related DocuBot predicts your query is to each document. A higher score indicates a stronger match, helping you quickly identify the most relevant sources for your search.")
        /// Display Similarity Score
        internal static let title = L10n.tr("Localizable", "Settings.Help.DisplaySimilarityScore.title", fallback: "Display Similarity Score")
      }
      internal enum DocumentPrefixCount {
        /// This value represents how many document excerpts we'll attach to your query when interfacing with the LLM.
        /// 
        /// A higher count will give DocuBot more insight into your project, but it can also overload the LLM with information and limit it's ability to provide a response.
        internal static let content = L10n.tr("Localizable", "Settings.Help.DocumentPrefixCount.content", fallback: "This value represents how many document excerpts we'll attach to your query when interfacing with the LLM.\n\nA higher count will give DocuBot more insight into your project, but it can also overload the LLM with information and limit it's ability to provide a response.")
        /// Document Prefix Count
        internal static let title = L10n.tr("Localizable", "Settings.Help.DocumentPrefixCount.title", fallback: "Document Prefix Count")
      }
      internal enum NumberOfQuestions {
        /// This value determines how many examples questions will be created during a sync of a project.
        /// 
        /// You can set this value to 0 to disable example questions entirely.
        internal static let content = L10n.tr("Localizable", "Settings.Help.NumberOfQuestions.content", fallback: "This value determines how many examples questions will be created during a sync of a project.\n\nYou can set this value to 0 to disable example questions entirely.")
        /// Number of Example Questions
        internal static let title = L10n.tr("Localizable", "Settings.Help.NumberOfQuestions.title", fallback: "Number of Example Questions")
      }
      internal enum SimilarityFloorScore {
        /// This value represents the minimum similarity score a document has to achieve to your query to be included in the context given to the LLM.
        internal static let content = L10n.tr("Localizable", "Settings.Help.SimilarityFloorScore.content", fallback: "This value represents the minimum similarity score a document has to achieve to your query to be included in the context given to the LLM.")
        /// Similarity Floor Score
        internal static let title = L10n.tr("Localizable", "Settings.Help.SimilarityFloorScore.title", fallback: "Similarity Floor Score")
      }
    }
    internal enum NumberOfQuestions {
      /// Number of Example Questions
      internal static let title = L10n.tr("Localizable", "Settings.NumberOfQuestions.title", fallback: "Number of Example Questions")
    }
    internal enum Section {
      internal enum Embedding {
        /// Embedding
        internal static let title = L10n.tr("Localizable", "Settings.Section.Embedding.title", fallback: "Embedding")
      }
      internal enum General {
        /// General
        internal static let title = L10n.tr("Localizable", "Settings.Section.General.title", fallback: "General")
      }
    }
    internal enum SimilarityFloorScore {
      /// Similarity Floor Score
      internal static let title = L10n.tr("Localizable", "Settings.SimilarityFloorScore.title", fallback: "Similarity Floor Score")
    }
  }
  internal enum SimilarityMetric {
    internal enum Cosine {
      /// Cosine
      internal static let title = L10n.tr("Localizable", "SimilarityMetric.Cosine.title", fallback: "Cosine")
    }
    internal enum DotProduct {
      /// Dot Product
      internal static let title = L10n.tr("Localizable", "SimilarityMetric.DotProduct.title", fallback: "Dot Product")
    }
    internal enum EuclideanDistance {
      /// Euclidean Distance
      internal static let title = L10n.tr("Localizable", "SimilarityMetric.EuclideanDistance.title", fallback: "Euclidean Distance")
    }
  }
  internal enum Welcome {
    /// Email the Developer
    internal static let emailDeveloper = L10n.tr("Localizable", "Welcome.emailDeveloper", fallback: "Email the Developer")
    /// Load New Project
    internal static let loadNewProject = L10n.tr("Localizable", "Welcome.loadNewProject", fallback: "Load New Project")
    /// Open Model Manager
    internal static let modelManager = L10n.tr("Localizable", "Welcome.modelManager", fallback: "Open Model Manager")
    /// Developed by William Lumley
    internal static let subtitle1 = L10n.tr("Localizable", "Welcome.subtitle1", fallback: "Developed by William Lumley")
    /// v%@(%@)
    internal static func subtitle2(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Welcome.subtitle2", String(describing: p1), String(describing: p2), fallback: "v%@(%@)")
    }
    /// Welcome to DocuBot
    internal static let title = L10n.tr("Localizable", "Welcome.title", fallback: "Welcome to DocuBot")
    /// View Source Code
    internal static let viewSourceCode = L10n.tr("Localizable", "Welcome.viewSourceCode", fallback: "View Source Code")
    internal enum Delete {
      internal enum Confirmation {
        /// Cancel
        internal static let cancelButton = L10n.tr("Localizable", "Welcome.Delete.Confirmation.cancelButton", fallback: "Cancel")
        /// Delete this Project
        internal static let deleteButton = L10n.tr("Localizable", "Welcome.Delete.Confirmation.deleteButton", fallback: "Delete this Project")
        /// Are you sure you want to delete this project?
        internal static let title = L10n.tr("Localizable", "Welcome.Delete.Confirmation.title", fallback: "Are you sure you want to delete this project?")
      }
    }
    internal enum EmptyModel {
      /// Choose a model to enable DocuBot's AI features and start exploring your documentation.
      internal static let subtitle = L10n.tr("Localizable", "Welcome.EmptyModel.subtitle", fallback: "Choose a model to enable DocuBot's AI features and start exploring your documentation.")
      /// Download a Model to get started
      internal static let title = L10n.tr("Localizable", "Welcome.EmptyModel.title", fallback: "Download a Model to get started")
    }
    internal enum EmptyProject {
      /// Your insights await – load a new project to get started
      internal static let subtitle = L10n.tr("Localizable", "Welcome.EmptyProject.subtitle", fallback: "Your insights await – load a new project to get started")
      /// Your project list is empty
      internal static let title = L10n.tr("Localizable", "Welcome.EmptyProject.title", fallback: "Your project list is empty")
    }
    internal enum ProjectContextMenu {
      /// Delete
      internal static let delete = L10n.tr("Localizable", "Welcome.ProjectContextMenu.delete", fallback: "Delete")
      /// Open
      internal static let `open` = L10n.tr("Localizable", "Welcome.ProjectContextMenu.open", fallback: "Open")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
