import Foundation
import llama

public struct Configuration {
    static let historySize = 5
    public let seed: UInt32
    public let topK: Int32
    public let topP: Float
    public let temperature: Float
    public let maxTokenCount: Int
    public let stopTokens: [String]

    public init(
        seed: UInt32 = 1234,
        topK: Int32 = 40,
        topP: Float = 0.9,
        temperature: Float = 0.2,
        stopSequence: String? = nil,
        maxTokenCount: Int = 1024,
        stopTokens: [String] = []
    ) {
        self.seed = seed
        self.topK = topK
        self.topP = topP
        self.temperature = temperature
        self.maxTokenCount = maxTokenCount
        self.stopTokens = stopTokens
    }
}

extension Configuration {
    var contextParameters: ContextParameters {
        var params = llama_context_default_params()
        let processorCount = max(1, min(16, ProcessInfo.processInfo.processorCount - 2))
        params.n_ctx = UInt32(self.maxTokenCount)
        params.n_threads = Int32(processorCount)
        params.n_threads_batch = Int32(processorCount)
        return params
    }
}
