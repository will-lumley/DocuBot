//
//  Error+DescriptionTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Foundation
import Testing

struct ErrorDescriptionTests {

    // MARK: - Types

    enum MockLocalizedError: LocalizedError {
        case test

        var errorDescription: String? {
            "this is a test error"
        }
    }

    enum MockError: Error {
        case test
    }

    // MARK: - Tests

    @Test("LocalizedError Description")
    func localizedErrorDescription() {
        #expect(MockLocalizedError.test.description == "this is a test error")
    }

    @Test("Error Description")
    func errorDescription() {
        let expected = """
        The operation couldn’t be completed. (DocuBotToolboxTests.ErrorDescriptionTests.MockError error 0.)
        """
        #expect(MockError.test.description == expected)
    }

}
