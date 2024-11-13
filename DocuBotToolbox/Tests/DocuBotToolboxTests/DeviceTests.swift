//
//  Device+Tests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct DeviceTests {

    @Test("Version Number")
    func versionNumber() {
        #expect(Device.versionNumber == "16.0")
    }

    @Test("Build Number")
    func buildNumber() {
        #expect(Device.buildNumber == "23196")
    }

}
