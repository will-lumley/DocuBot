//
//  Optional+ThrowTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct OptionalOrThrowTests {

    // MARK: - Types

    enum MockError: Error {
        case test
    }

    // MARK: - Tests

    @Test("Unwraps Properly")
    func unwrapsProperly() throws {
        let wrappedValue: String? = "Hello, World!"
        let unwrapped = try wrappedValue.orThrow(MockError.test)

        #expect(unwrapped == "Hello, World!")
    }

    @Test("Throws Properly")
    func throwsProperly() {
        #expect(throws: MockError.test) {
            let wrappedValue: String? = nil
            _ = try wrappedValue.orThrow(MockError.test)
        }
    }

}
