//
//  String+ChecksumTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Foundation
import Testing

struct StringChecksumTests {

    @Test("Checksum with Known String")
    func checksumWithKnownString() {
        let testSubject = "Hello, World!"
        let expected = "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"

        #expect(testSubject.checksum == expected)
    }

    @Test("Checksum with Empty String")
    func testChecksumWithEmptyString() {
        let testSubject = ""
        let expected = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

        #expect(testSubject.checksum == expected)
    }

    @Test("Checksum Uniqueness")
    func checksumWithInvalidString() throws {
        let firstString = "First String"
        let secondString = "Second String"

        #expect(firstString.checksum != secondString.checksum)
    }

}
