public enum GPTError: LocalizedError {
    case noModel(modelName: String)
    case failedToCreateLLMDecodingError
    case failedToCreateLLM(reason: String)
    case llmNotInitialised

    public var errorDescription: String? {
        switch self {
        case .noModel(let modelName):
            return L10n.Error.Gpt.noModel(modelName)
        case .failedToCreateLLMDecodingError:
            return L10n.Error.Gpt.failedToCreateLLMDecodingError
        case .failedToCreateLLM(let reason):
            return L10n.Error.Gpt.failedToCreateLLM(reason)
        case .llmNotInitialised:
            return L10n.Error.Gpt.llmNotInitialised
        }
    }
}
