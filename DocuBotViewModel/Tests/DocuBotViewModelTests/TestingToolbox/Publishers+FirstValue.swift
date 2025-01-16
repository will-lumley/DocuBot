//
//  Publishers+FirstValue.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

import Combine

@MainActor
extension Publisher {
    
    /// Converts a Publisher to an async sequence and returns the first value emitted.
    func firstValue() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        Task { @MainActor in
                            continuation.resume(returning: value)
                            cancellable?.cancel()
                        }
                    }
                )
        }
    }
    
    func firstCompactValue() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .compactMap(\.self)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        Task { @MainActor in
                            continuation.resume(returning: value)
                            cancellable?.cancel()
                        }
                    }
                )
        }
    }

    func firstValueAfterDrop() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .dropFirst()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        Task { @MainActor in
                            continuation.resume(returning: value)
                            cancellable?.cancel()
                        }
                    }
                )
        }
    }

}
