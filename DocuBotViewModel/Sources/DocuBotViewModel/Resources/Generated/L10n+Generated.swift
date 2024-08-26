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
    /// Project Settings
    internal static let formTitle = L10n.tr("Localizable", "CreateProject.formTitle", fallback: "Project Settings")
    /// Create Project
    internal static let windowTitle = L10n.tr("Localizable", "CreateProject.windowTitle", fallback: "Create Project")
    internal enum Configuration {
      internal enum Directory {
        /// Select a Directory
        internal static let select = L10n.tr("Localizable", "CreateProject.Configuration.Directory.select", fallback: "Select a Directory")
      }
      internal enum Format {
        /// Add Custom Format
        internal static let addFormatButton = L10n.tr("Localizable", "CreateProject.Configuration.Format.addFormatButton", fallback: "Add Custom Format")
        /// .html
        internal static let html = L10n.tr("Localizable", "CreateProject.Configuration.Format.html", fallback: ".html")
        /// .md
        internal static let md = L10n.tr("Localizable", "CreateProject.Configuration.Format.md", fallback: ".md")
        /// Other
        internal static let other = L10n.tr("Localizable", "CreateProject.Configuration.Format.other", fallback: "Other")
        /// .rtf
        internal static let rtf = L10n.tr("Localizable", "CreateProject.Configuration.Format.rtf", fallback: ".rtf")
        /// .txt
        internal static let txt = L10n.tr("Localizable", "CreateProject.Configuration.Format.txt", fallback: ".txt")
      }
      internal enum FormatSection {
        /// What format is your documentation in?
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.FormatSection.title", fallback: "What format is your documentation in?")
      }
      internal enum GeneralSection {
        /// General
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.GeneralSection.title", fallback: "General")
      }
      internal enum Language {
        /// English
        internal static let english = L10n.tr("Localizable", "CreateProject.Configuration.Language.english", fallback: "English")
        /// Español
        internal static let espanol = L10n.tr("Localizable", "CreateProject.Configuration.Language.espanol", fallback: "Español")
        /// Language
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.Language.title", fallback: "Language")
      }
      internal enum Name {
        /// Project Name
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.Name.title", fallback: "Project Name")
      }
      internal enum ProjectDirectory {
        /// Project Directory
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.ProjectDirectory.title", fallback: "Project Directory")
      }
    }
  }
  internal enum Project {
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
    internal enum NewChat {
      /// New Chat
      internal static let defaultTitle = L10n.tr("Localizable", "Project.NewChat.defaultTitle", fallback: "New Chat")
    }
  }
  internal enum ProjectPicker {
    /// Email the Developer
    internal static let emailDeveloper = L10n.tr("Localizable", "ProjectPicker.emailDeveloper", fallback: "Email the Developer")
    /// Your insights await – load a new project to get started
    internal static let emptyProjectSubtitle = L10n.tr("Localizable", "ProjectPicker.emptyProjectSubtitle", fallback: "Your insights await – load a new project to get started")
    /// Your project list is empty
    internal static let emptyProjectTitle = L10n.tr("Localizable", "ProjectPicker.emptyProjectTitle", fallback: "Your project list is empty")
    /// Load New Project
    internal static let loadNewProject = L10n.tr("Localizable", "ProjectPicker.loadNewProject", fallback: "Load New Project")
    /// Developed by William Lumley
    internal static let subtitle1 = L10n.tr("Localizable", "ProjectPicker.subtitle1", fallback: "Developed by William Lumley")
    /// v%@(%@)
    internal static func subtitle2(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "ProjectPicker.subtitle2", String(describing: p1), String(describing: p2), fallback: "v%@(%@)")
    }
    /// Welcome to DocuBot
    internal static let title = L10n.tr("Localizable", "ProjectPicker.title", fallback: "Welcome to DocuBot")
    /// View Source Code
    internal static let viewSourceCode = L10n.tr("Localizable", "ProjectPicker.viewSourceCode", fallback: "View Source Code")
    internal enum Delete {
      internal enum Confirmation {
        /// Cancel
        internal static let cancelButton = L10n.tr("Localizable", "ProjectPicker.Delete.Confirmation.cancelButton", fallback: "Cancel")
        /// Delete this Project
        internal static let deleteButton = L10n.tr("Localizable", "ProjectPicker.Delete.Confirmation.deleteButton", fallback: "Delete this Project")
        /// Are you sure you want to delete this project?
        internal static let title = L10n.tr("Localizable", "ProjectPicker.Delete.Confirmation.title", fallback: "Are you sure you want to delete this project?")
      }
    }
    internal enum ProjectContextMenu {
      /// Delete
      internal static let delete = L10n.tr("Localizable", "ProjectPicker.ProjectContextMenu.delete", fallback: "Delete")
      /// Open
      internal static let `open` = L10n.tr("Localizable", "ProjectPicker.ProjectContextMenu.open", fallback: "Open")
      /// Show in Finder
      internal static let showInFinder = L10n.tr("Localizable", "ProjectPicker.ProjectContextMenu.showInFinder", fallback: "Show in Finder")
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
