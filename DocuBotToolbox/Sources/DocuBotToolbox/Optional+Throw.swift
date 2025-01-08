//
//  Optional+Throw.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/10/2024.
//

/// An extension on `Optional` to provide a method for unwrapping with error throwing.
public extension Optional {

    /// Unwraps the optional value or throws a custom error if the value is `nil`.
    ///
    /// This method attempts to retrieve the wrapped value of the optional. If the optional is `nil`, it
    /// throws the provided error.
    ///
    /// - Parameter error: An autoclosure that generates the error to throw if the optional is `nil`.
    /// - Throws: The custom error provided by the `error` parameter.
    /// - Returns: The unwrapped value of the optional.
    func orThrow<E: Error>(_ error: @autoclosure () -> E) throws -> Wrapped {
        guard let wrapped = self else {
            throw error()
        }
        return wrapped
    }

}
