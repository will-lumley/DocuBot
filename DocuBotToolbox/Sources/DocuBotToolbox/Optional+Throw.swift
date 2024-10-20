//
//  Optional+Throw.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/10/2024.
//

public extension Optional {

    func orThrow<E: Error>(_ error: @autoclosure () -> E) throws(E) -> Wrapped {
        guard let wrapped = self else {
            throw error()
        }
        return wrapped
    }

}
