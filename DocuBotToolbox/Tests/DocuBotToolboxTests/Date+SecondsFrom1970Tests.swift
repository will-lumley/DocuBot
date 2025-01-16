//
//  Date+SecondsFrom1970Tests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/11/2024.
//

@testable import DocuBotToolbox
import Foundation
import Testing

struct DateSecondsSince1970Tests {

    @Test
    func testSecondsFrom1970() {
        // Test with a known fixed date
        let fixedDate = Date(timeIntervalSince1970: 1_000_000)
        #expect(fixedDate.secondsFrom1970 == 1_000_000)

        // Test with epoch date
        let epochDate = Date(timeIntervalSince1970: 0)
        #expect(epochDate.secondsFrom1970 == 0)

        // Test with a future date
        let futureDate = Date(timeIntervalSince1970: 2_000_000_000)
        #expect(futureDate.secondsFrom1970 == 2_000_000_000)

        // Test with a negative interval (before epoch)
        let negativeDate = Date(timeIntervalSince1970: -1_000)
        #expect(negativeDate.secondsFrom1970 == -1_000)
    }

}
