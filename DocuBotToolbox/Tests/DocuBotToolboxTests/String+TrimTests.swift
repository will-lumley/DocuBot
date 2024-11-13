//
//  String+TrimTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct StringTrimTests {

    @Test("Removing Value")
    func removingValue() {
        let testSubject1 = "Hello there my name is Will"
        let modified1 = testSubject1.removing(value: " is Will")
        #expect(modified1 == "Hello there my name")

        let testSubject2 = "Hello there! Oh Hello there!"
        let modified2 = testSubject2.removing(value: "Hello there!")
        #expect(modified2 == " Oh ")
    }

    @Test("Removing Prefix Up To")
    func removingPrefixUpTo() {
        let testSubject = "Hello there my name is Will"
        let modified = testSubject.removingPrefix(upTo: "name ")

        #expect(modified == "is Will")
    }

    @Test("Trimming Trailing Newlines")
    func trimmingTrailingNewlines() {
        let testSubject = "Hi.\n\nHello there.\nMy name is Will.\n\n"
        let modified = testSubject.trimmingTrailingNewlines()

        #expect(modified == "Hi.\n\nHello there.\nMy name is Will.")
    }

    @Test("Trim By Length")
    func trimByLength() {
        let testSubject = "123456789"
        let modified = testSubject.trim(by: 4)

        #expect(modified == "1234")
    }

}
