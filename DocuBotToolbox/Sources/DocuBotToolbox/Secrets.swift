import Foundation

/// A namespace for storing app-related constants and secrets.
///
/// The `Secrets` enum organizes various categories of constants, such as bundle identifiers,
/// app information, and model download URLs. Each nested enum provides related constants
/// in a structured manner.
public enum Secrets {

    /// Constants related to app bundle identifiers and app group configurations.
    public enum BundleIDs {
        public static let docubot = "com.williamlumley.docubot"
        public static let settings = "\(docubot).settings"
        public static let appGroup = "4ELTP9RFTJ.group.\(docubot)"
    }

    /// Constants related to app information, such as URLs and contact details.
    public enum AppInfo {
        public static let licenceURL = "https://github.com/will-lumley/DocuBot?tab=GPL-3.0-1-ov-file"
        public static let privacyPolicyURL = "https://github.com/will-lumley/DocuBot/blob/main/PrivacyPolicy.pdf"
        public static let sourceCodeURL = "https://github.com/will-lumley/DocuBot"
        public static let developerEmail = "will@lumley.io"
    }

    /// Constants for managing model download URLs.
    public enum ModelDownloads {
        // swiftlint:disable:next line_length
        public static let defaultModel = "https://huggingface.co/QuantFactory/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct.Q3_K_M.gguf"

        public static let testModel = "https://s28.q4cdn.com/392171258/files/doc_downloads/test.pdf"
    }

}
