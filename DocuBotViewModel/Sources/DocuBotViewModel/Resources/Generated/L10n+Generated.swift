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
    /// Create Project
    internal static let windowTitle = L10n.tr("Localizable", "CreateProject.windowTitle", fallback: "Create Project")
    internal enum Configuration {
      internal enum Format {
        /// .html
        internal static let html = L10n.tr("Localizable", "CreateProject.Configuration.Format.html", fallback: ".html")
        /// .md
        internal static let md = L10n.tr("Localizable", "CreateProject.Configuration.Format.md", fallback: ".md")
        /// .rtf
        internal static let rtf = L10n.tr("Localizable", "CreateProject.Configuration.Format.rtf", fallback: ".rtf")
        /// What format is your documentation in?
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.Format.title", fallback: "What format is your documentation in?")
        /// .txt
        internal static let txt = L10n.tr("Localizable", "CreateProject.Configuration.Format.txt", fallback: ".txt")
      }
      internal enum ProjectDirectory {
        /// Project Directory
        internal static let title = L10n.tr("Localizable", "CreateProject.Configuration.ProjectDirectory.title", fallback: "Project Directory")
      }
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
