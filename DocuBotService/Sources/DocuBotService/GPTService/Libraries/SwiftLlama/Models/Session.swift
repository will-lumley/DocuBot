import Foundation

struct Session {
    private var history: [SwiftLlama.Chat] = []
    var lastPrompt: SwiftLlama.Prompt
    var currentResponse: String = ""

    init(history: [SwiftLlama.Chat] = [], lastPrompt: SwiftLlama.Prompt) {
        self.history = history
        self.lastPrompt = lastPrompt
    }

    mutating func endResponse() {
        history.append(
            SwiftLlama.Chat(user: lastPrompt.userMessage, bot: currentResponse)
        )
        currentResponse = ""
    }

    mutating func response(delta: String) {
        currentResponse += delta
    }

    var sessionPrompt: SwiftLlama.Prompt {
        .init(
            type: lastPrompt.type,
            systemPrompt: lastPrompt.systemPrompt,
            userMessage: lastPrompt.userMessage,
            history: history
        )
    }
}
