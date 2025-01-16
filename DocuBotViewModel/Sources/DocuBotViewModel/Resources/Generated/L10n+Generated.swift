// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
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
