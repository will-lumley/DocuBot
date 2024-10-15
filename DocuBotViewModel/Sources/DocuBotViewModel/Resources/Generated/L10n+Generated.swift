// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum CreateProject {
    /// Create Project
    internal static let createButton = L10n.tr("Localizable", "CreateProject.createButton", fallback: "Create Project")
    /// Create your new project
    internal static let formTitle = L10n.tr("Localizable", "CreateProject.formTitle", fallback: "Create your new project")
    /// Create Project
    internal static let windowTitle = L10n.tr("Localizable", "CreateProject.windowTitle", fallback: "Create Project")
    internal enum AdvancedSection {
      /// Batch Size
      internal static let batchSize = L10n.tr("Localizable", "CreateProject.AdvancedSection.batchSize", fallback: "Batch Size")
      /// Context Length
      internal static let contextLength = L10n.tr("Localizable", "CreateProject.AdvancedSection.contextLength", fallback: "Context Length")
      /// Maximum Token Count
      internal static let maxTokenCount = L10n.tr("Localizable", "CreateProject.AdvancedSection.maxTokenCount", fallback: "Maximum Token Count")
      /// Reset Default Values
      internal static let resetDefaults = L10n.tr("Localizable", "CreateProject.AdvancedSection.resetDefaults", fallback: "Reset Default Values")
      /// Seed
      internal static let seed = L10n.tr("Localizable", "CreateProject.AdvancedSection.seed", fallback: "Seed")
      /// Stop Sequence
      internal static let stopSequence = L10n.tr("Localizable", "CreateProject.AdvancedSection.stopSequence", fallback: "Stop Sequence")
      /// These settings are optional, and the defaults work for most cases. Adjust them only if you need something specific.
      internal static let subtitle = L10n.tr("Localizable", "CreateProject.AdvancedSection.subtitle", fallback: "These settings are optional, and the defaults work for most cases. Adjust them only if you need something specific.")
      /// Temperature
      internal static let temperature = L10n.tr("Localizable", "CreateProject.AdvancedSection.temperature", fallback: "Temperature")
      /// Advanced Configuration
      internal static let title = L10n.tr("Localizable", "CreateProject.AdvancedSection.title", fallback: "Advanced Configuration")
      /// Top K
      internal static let topK = L10n.tr("Localizable", "CreateProject.AdvancedSection.topK", fallback: "Top K")
      /// Top P
      internal static let topP = L10n.tr("Localizable", "CreateProject.AdvancedSection.topP", fallback: "Top P")
    }
    internal enum Configuration {
      internal enum Directory {
        /// Select a Directory
        internal static let select = L10n.tr("Localizable", "CreateProject.Configuration.Directory.select", fallback: "Select a Directory")
      }
    }
    internal enum Error {
      internal enum FailedToCreate {
        /// Failed to Create Project
        internal static let title = L10n.tr("Localizable", "CreateProject.Error.FailedToCreate.title", fallback: "Failed to Create Project")
      }
    }
    internal enum FormatSection {
      /// We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later.
      internal static let subtitle = L10n.tr("Localizable", "CreateProject.FormatSection.subtitle", fallback: "We don't yet support any formats like Microsoft Word or PDF, but we hope to support more complex formats later.")
      /// What format is your documentation in?
      internal static let title = L10n.tr("Localizable", "CreateProject.FormatSection.title", fallback: "What format is your documentation in?")
      internal enum Format {
        /// Add Custom Format
        internal static let addFormatButton = L10n.tr("Localizable", "CreateProject.FormatSection.Format.addFormatButton", fallback: "Add Custom Format")
        /// .html
        internal static let html = L10n.tr("Localizable", "CreateProject.FormatSection.Format.html", fallback: ".html")
        /// .md
        internal static let md = L10n.tr("Localizable", "CreateProject.FormatSection.Format.md", fallback: ".md")
        /// Other
        internal static let other = L10n.tr("Localizable", "CreateProject.FormatSection.Format.other", fallback: "Other")
        /// .rtf
        internal static let rtf = L10n.tr("Localizable", "CreateProject.FormatSection.Format.rtf", fallback: ".rtf")
        /// .txt
        internal static let txt = L10n.tr("Localizable", "CreateProject.FormatSection.Format.txt", fallback: ".txt")
      }
    }
    internal enum GeneralSection {
      /// Tell us a bit about your project.
      internal static let subtitle = L10n.tr("Localizable", "CreateProject.GeneralSection.subtitle", fallback: "Tell us a bit about your project.")
      /// General
      internal static let title = L10n.tr("Localizable", "CreateProject.GeneralSection.title", fallback: "General")
      internal enum Directory {
        /// Project Directory
        internal static let title = L10n.tr("Localizable", "CreateProject.GeneralSection.Directory.title", fallback: "Project Directory")
      }
      internal enum Language {
        /// English
        internal static let english = L10n.tr("Localizable", "CreateProject.GeneralSection.Language.english", fallback: "English")
        /// Español
        internal static let espanol = L10n.tr("Localizable", "CreateProject.GeneralSection.Language.espanol", fallback: "Español")
        /// Language
        internal static let title = L10n.tr("Localizable", "CreateProject.GeneralSection.Language.title", fallback: "Language")
      }
      internal enum Name {
        /// Project Name
        internal static let title = L10n.tr("Localizable", "CreateProject.GeneralSection.Name.title", fallback: "Project Name")
      }
    }
    internal enum Help {
      internal enum BatchSize {
        /// This parameter defines the number of tokens processed in one batch during the generation or training phase.
        /// 
        /// A batch size of 2048 means the model processes up to 2048 tokens at once. This can affect both the memory usage and performance during generation.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.BatchSize.content", fallback: "This parameter defines the number of tokens processed in one batch during the generation or training phase.\n\nA batch size of 2048 means the model processes up to 2048 tokens at once. This can affect both the memory usage and performance during generation.")
        /// What does batch size do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.BatchSize.title", fallback: "What does batch size do?")
      }
      internal enum ContextLength {
        /// The context length defines how many tokens the model can consider at once when generating text.
        /// 
        /// By default, the model can use up to 2048 tokens of context, allowing it to maintain and use information over a relatively long span of generated text.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.ContextLength.content", fallback: "The context length defines how many tokens the model can consider at once when generating text.\n\nBy default, the model can use up to 2048 tokens of context, allowing it to maintain and use information over a relatively long span of generated text.")
        /// What does context length do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.ContextLength.title", fallback: "What does context length do?")
      }
      internal enum MaxTokenCount {
        /// This sets the maximum number of tokens the model is allowed to generate.
        /// 
        /// Even if the model hasn’t hit a stopping condition (such as a stop sequence), it will stop once it generates the specified amount of tokens.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.MaxTokenCount.content", fallback: "This sets the maximum number of tokens the model is allowed to generate.\n\nEven if the model hasn’t hit a stopping condition (such as a stop sequence), it will stop once it generates the specified amount of tokens.")
        /// What does max token count do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.MaxTokenCount.title", fallback: "What does max token count do?")
      }
      internal enum Seed {
        /// The seed value is used to initialise the random number generator, which influences how the model generates text.
        /// 
        /// By setting a seed, you ensure that the generation process is deterministic - running the same input with the same seed will result in the same output. This is useful for reproducibility.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.Seed.content", fallback: "The seed value is used to initialise the random number generator, which influences how the model generates text.\n\nBy setting a seed, you ensure that the generation process is deterministic - running the same input with the same seed will result in the same output. This is useful for reproducibility.")
        /// What does seed do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.Seed.title", fallback: "What does seed do?")
      }
      internal enum StopSequence {
        /// If a stop sequence is specified, the generation will stop when the model generates the provided string sequence.
        /// 
        /// This is useful when you want to halt the model’s output after a certain phrase or token appears. If set to blank, the model will continue generating text until it reaches the maximum token limit or another stopping condition.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.StopSequence.content", fallback: "If a stop sequence is specified, the generation will stop when the model generates the provided string sequence.\n\nThis is useful when you want to halt the model’s output after a certain phrase or token appears. If set to blank, the model will continue generating text until it reaches the maximum token limit or another stopping condition.")
        /// What does stop sequence do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.StopSequence.title", fallback: "What does stop sequence do?")
      }
      internal enum Temperature {
        /// Temperature controls the "creativity" or randomness of the output.
        /// 
        /// A lower temperature (e.g., 0.2) makes the model more conservative and focused on high-probability tokens, leading to more predictable and repetitive outputs. A higher temperature makes the model more creative and prone to selecting less likely tokens.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.Temperature.content", fallback: "Temperature controls the \"creativity\" or randomness of the output.\n\nA lower temperature (e.g., 0.2) makes the model more conservative and focused on high-probability tokens, leading to more predictable and repetitive outputs. A higher temperature makes the model more creative and prone to selecting less likely tokens.")
        /// What does temperature do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.Temperature.title", fallback: "What does temperature do?")
      }
      internal enum TopK {
        /// Top-K sampling limits the model to choosing from only the top K most likely next tokens (words, subwords, etc.).
        /// 
        /// By default, K is set to 40, meaning the model will only consider the 40 most probable next tokens, adding an element of randomness while ensuring more likely tokens are preferred.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.TopK.content", fallback: "Top-K sampling limits the model to choosing from only the top K most likely next tokens (words, subwords, etc.).\n\nBy default, K is set to 40, meaning the model will only consider the 40 most probable next tokens, adding an element of randomness while ensuring more likely tokens are preferred.")
        /// What does top-k do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.TopK.title", fallback: "What does top-k do?")
      }
      internal enum TopP {
        /// Top-P sampling (also known as nucleus sampling) dynamically selects the smallest possible set of tokens whose cumulative probability exceeds P.
        /// 
        /// By default, P is 0.9, so the model will sample from the top 90 percent of the probability mass, making it more flexible than top-K and helping balance between randomness and determinism in the generation.
        internal static let content = L10n.tr("Localizable", "CreateProject.Help.TopP.content", fallback: "Top-P sampling (also known as nucleus sampling) dynamically selects the smallest possible set of tokens whose cumulative probability exceeds P.\n\nBy default, P is 0.9, so the model will sample from the top 90 percent of the probability mass, making it more flexible than top-K and helping balance between randomness and determinism in the generation.")
        /// What does top-p do?
        internal static let title = L10n.tr("Localizable", "CreateProject.Help.TopP.title", fallback: "What does top-p do?")
      }
    }
  }
  internal enum Project {
    /// Ask any question about your project.
    internal static let queryTitle = L10n.tr("Localizable", "Project.queryTitle", fallback: "Ask any question about your project.")
    internal enum Chat {
      internal enum NothingSelected {
        /// No chat selected
        internal static let title = L10n.tr("Localizable", "Project.Chat.NothingSelected.title", fallback: "No chat selected")
      }
    }
    internal enum ChatContextMenu {
      /// Delete
      internal static let delete = L10n.tr("Localizable", "Project.ChatContextMenu.delete", fallback: "Delete")
      /// Rename
      internal static let rename = L10n.tr("Localizable", "Project.ChatContextMenu.rename", fallback: "Rename")
    }
    internal enum Delete {
      internal enum Confirmation {
        /// Cancel
        internal static let cancelButton = L10n.tr("Localizable", "Project.Delete.Confirmation.cancelButton", fallback: "Cancel")
        /// Delete this Chat
        internal static let deleteButton = L10n.tr("Localizable", "Project.Delete.Confirmation.deleteButton", fallback: "Delete this Chat")
        /// Are you sure you want to delete this chat?
        internal static let title = L10n.tr("Localizable", "Project.Delete.Confirmation.title", fallback: "Are you sure you want to delete this chat?")
      }
    }
    internal enum EmptyChat {
      /// Create a chat with the button below to get started
      internal static let subtitle = L10n.tr("Localizable", "Project.EmptyChat.subtitle", fallback: "Create a chat with the button below to get started")
      /// No Chats
      internal static let title = L10n.tr("Localizable", "Project.EmptyChat.title", fallback: "No Chats")
    }
    internal enum EmptyMessages {
      /// Type something into the textfield below to get started
      internal static let subtitle = L10n.tr("Localizable", "Project.EmptyMessages.subtitle", fallback: "Type something into the textfield below to get started")
      /// No Messages
      internal static let title = L10n.tr("Localizable", "Project.EmptyMessages.title", fallback: "No Messages")
    }
    internal enum LlmQueryPrompt {
      /// Given the following extracted parts of a long document and a question, create a final answer with references ("SOURCES").
      ///             If you don't know the answer, just say that you don't know. Don't try to make up an answer.
      ///             ALWAYS return a "SOURCES" part in your answer.
      /// QUESTION: %@
      /// =========
      /// %@
      /// =========
      /// FINAL ANSWER:
      internal static func template(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Project.LlmQueryPrompt.template", String(describing: p1), String(describing: p2), fallback: "Given the following extracted parts of a long document and a question, create a final answer with references (\"SOURCES\").\n            If you don't know the answer, just say that you don't know. Don't try to make up an answer.\n            ALWAYS return a \"SOURCES\" part in your answer.\nQUESTION: %@\n=========\n%@\n=========\nFINAL ANSWER:")
      }
    }
    internal enum NewChat {
      /// New Chat
      internal static let defaultTitle = L10n.tr("Localizable", "Project.NewChat.defaultTitle", fallback: "New Chat")
    }
  }
  internal enum ProjectSettings {
    /// Save Settings
    internal static let saveButton = L10n.tr("Localizable", "ProjectSettings.saveButton", fallback: "Save Settings")
    /// Project Settings
    internal static let windowTitle = L10n.tr("Localizable", "ProjectSettings.windowTitle", fallback: "Project Settings")
  }
  internal enum Welcome {
    /// Email the Developer
    internal static let emailDeveloper = L10n.tr("Localizable", "Welcome.emailDeveloper", fallback: "Email the Developer")
    /// Your insights await – load a new project to get started
    internal static let emptyProjectSubtitle = L10n.tr("Localizable", "Welcome.emptyProjectSubtitle", fallback: "Your insights await – load a new project to get started")
    /// Your project list is empty
    internal static let emptyProjectTitle = L10n.tr("Localizable", "Welcome.emptyProjectTitle", fallback: "Your project list is empty")
    /// Load New Project
    internal static let loadNewProject = L10n.tr("Localizable", "Welcome.loadNewProject", fallback: "Load New Project")
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
    internal enum Error {
      internal enum FailedToDelete {
        /// DocuBot failed to delete the project. Please try again.
        internal static let message = L10n.tr("Localizable", "Welcome.Error.FailedToDelete.message", fallback: "DocuBot failed to delete the project. Please try again.")
        /// Failed to Delete Project
        internal static let title = L10n.tr("Localizable", "Welcome.Error.FailedToDelete.title", fallback: "Failed to Delete Project")
      }
    }
    internal enum ProjectContextMenu {
      /// Delete
      internal static let delete = L10n.tr("Localizable", "Welcome.ProjectContextMenu.delete", fallback: "Delete")
      /// Open
      internal static let `open` = L10n.tr("Localizable", "Welcome.ProjectContextMenu.open", fallback: "Open")
      /// Show in Finder
      internal static let showInFinder = L10n.tr("Localizable", "Welcome.ProjectContextMenu.showInFinder", fallback: "Show in Finder")
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
