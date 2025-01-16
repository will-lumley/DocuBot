import Foundation

public enum Secrets {

    public enum BundleIDs {
        public static let docubot = "com.williamlumley.docubot"
        public static let settings = "\(docubot).settings"
        public static let appGroup = "4ELTP9RFTJ.group.\(docubot)"
    }

    public enum AppInfo {
        public static let licnceURL = ""
        public static let privacyPolicyURL = ""
        public static let sourceCodeURL = "https://github.com/will-lumley/DocuBot"
        public static let developerEmail = "will@lumley.io"
    }

    public enum ModelDownloads {
        // swiftlint:disable:next line_length
        public static let defaultModel = "https://huggingface.co/QuantFactory/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct.Q3_K_M.gguf"

        public static let testModel = "https://s28.q4cdn.com/392171258/files/doc_downloads/test.pdf"
    }

}
