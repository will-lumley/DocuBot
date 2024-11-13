//
//  Sequence+AsyncMapTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct SequenceAsyncMapTests {

    // MARK: - Types

    enum MockError: Error {
        case test
    }

    // MARK: - Tests

    @Test("AsyncMap with Success")
    func asyncMapWithSuccess() async {
        let values = [1, 2, 3, 4]
        let result = await values.asyncMap { element in
            return element * 2
        }

        #expect(result == [2, 4, 6, 8])
    }

    @Test("AsyncMap with Error")
    func asyncMapWithError() async {
        let values = ["1", "2", "three", "4"]

        do {
            _ = try await values.asyncMap { element in
                guard let intValue = Int(element) else {
                    throw MockError.test
                }
                return intValue * 2
            }
            Issue.record("`asyncMap` did not throw error.")
        } catch {
            guard let mockError = error as? MockError else {
                Issue.record("Error should be `MockError`.")
                return
            }
            #expect(mockError == .test)
        }
    }

}
