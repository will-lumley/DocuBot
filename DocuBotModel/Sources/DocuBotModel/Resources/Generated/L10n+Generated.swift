// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Document {
    internal enum LlmReference {
      /// SOURCES: %@
      /// %@
      internal static func template(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "Document.LlmReference.template", String(describing: p1), String(describing: p2), fallback: "SOURCES: %@\n%@")
      }
    }
  }
  internal enum Error {
    internal enum ContentExtraction {
      /// Failed to read the file's contents.
      internal static let failedToReadContent = L10n.tr("Localizable", "Error.ContentExtraction.failedToReadContent", fallback: "Failed to read the file's contents.")
      /// Failed to find the file on your computer.
      internal static let failedToReadFile = L10n.tr("Localizable", "Error.ContentExtraction.failedToReadFile", fallback: "Failed to find the file on your computer.")
    }
    internal enum Document {
      /// Bookmark is stale. Please try syncing again.
      internal static let bookmarkIsStale = L10n.tr("Localizable", "Error.Document.bookmarkIsStale", fallback: "Bookmark is stale. Please try syncing again.")
      /// Failed to generate a checksum for document.
      internal static let checksumGeneration = L10n.tr("Localizable", "Error.Document.checksumGeneration", fallback: "Failed to generate a checksum for document.")
      /// Failed to perform the operation due to missing document ID.
      internal static let missingID = L10n.tr("Localizable", "Error.Document.missingID", fallback: "Failed to perform the operation due to missing document ID.")
      /// No bookmark data found. Please try syncing again.
      internal static let noBookmarkData = L10n.tr("Localizable", "Error.Document.noBookmarkData", fallback: "No bookmark data found. Please try syncing again.")
    }
    internal enum Model {
      /// The model binary is missing or corrupted. Please reload the model from the Model Manager.
      internal static let binaryMissing = L10n.tr("Localizable", "Error.Model.binaryMissing", fallback: "The model binary is missing or corrupted. Please reload the model from the Model Manager.")
      /// Failed to perform the operation due to missing model ID.
      internal static let missingID = L10n.tr("Localizable", "Error.Model.missingID", fallback: "Failed to perform the operation due to missing model ID.")
    }
    internal enum Project {
      /// Failed to perform the operation due to missing project ID.
      internal static let missingID = L10n.tr("Localizable", "Error.Project.missingID", fallback: "Failed to perform the operation due to missing project ID.")
      internal enum DocumentFetch {
        /// Failed to fetch documents as no documents found for the project.
        internal static let noDocumentsFound = L10n.tr("Localizable", "Error.Project.DocumentFetch.noDocumentsFound", fallback: "Failed to fetch documents as no documents found for the project.")
        /// Failed to perform the operation as document indexing has not been completed.
        internal static let noIndexing = L10n.tr("Localizable", "Error.Project.DocumentFetch.noIndexing", fallback: "Failed to perform the operation as document indexing has not been completed.")
      }
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
