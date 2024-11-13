//
//  ProgressTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct ProgressTests {

    @Test("Initialisation")
    func initialisation() {
        let testSubject = Progress(value: 5, total: 10)

        #expect(testSubject.value == 5)
        #expect(testSubject.total == 10)
    }

    @Test("Percentage")
    func percentage() {
        let testSubject = Progress(value: 5, total: 10)
        #expect(testSubject.percentage == 50)
    }

}
