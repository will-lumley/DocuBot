//
//  Sequence+AsyncMap.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 6/10/2024.
//

/// An extension on `Sequence` to provide an asynchronous version of `map`.
///
/// The `asyncMap` method allows transforming each element in a sequence asynchronously,
/// supporting `async` and `throws` transformations.
///
/// - Note: This implementation is inspired by an article on
/// [Swift by Sundell](https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/).
public extension Sequence {
    
    /// Applies an asynchronous transformation to each element of the sequence.
    ///
    /// This method iterates through the sequence and applies the provided `transform` function
    /// to each element asynchronously. If the `transform` function throws an error, the execution halts,
    /// and the error is propagated.
    ///
    /// - Parameter transform: An asynchronous throwing closure that transforms each element of the sequence.
    /// - Returns: An array of transformed elements of type `T`.
    /// - Throws: An error if the `transform` closure throws an error.
    /// - Note: Execution of the `transform` closure happens sequentially for each element.
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

}
