// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Error {
    internal enum Gpt {
      /// Failed to create LLM. %@.
      internal static func failedToCreateLLM(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Error.GPT.failedToCreateLLM", String(describing: p1), fallback: "Failed to create LLM. %@.")
      }
      /// Failed to create LLM due to a decoding error.
      internal static let failedToCreateLLMDecodingError = L10n.tr("Localizable", "Error.GPT.failedToCreateLLMDecodingError", fallback: "Failed to create LLM due to a decoding error.")
      /// LLM Instance is not initialised.
      internal static let llmNotInitialised = L10n.tr("Localizable", "Error.GPT.llmNotInitialised", fallback: "LLM Instance is not initialised.")
      /// Failed to find the selected model, %@.
      internal static func noModel(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Error.GPT.noModel", String(describing: p1), fallback: "Failed to find the selected model, %@.")
      }
    }
    internal enum Persistence {
      /// Failed to find the necessary data in the database for this operation.
      internal static let valueNotFound = L10n.tr("Localizable", "Error.Persistence.valueNotFound", fallback: "Failed to find the necessary data in the database for this operation.")
    }
  }
  internal enum Log {
    internal enum LogType {
      /// [ERROR]
      internal static let error = L10n.tr("Localizable", "Log.LogType.error", fallback: "[ERROR]")
      /// [INFO]
      internal static let info = L10n.tr("Localizable", "Log.LogType.info", fallback: "[INFO]")
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
