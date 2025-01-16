//
//  Device.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 12/10/2024.
//

import Foundation

public struct Device {

    public static var versionNumber: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1"
    }

    public static var buildNumber: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "1.0"
    }

    public static var isUnitTesting: Bool {
        let envInfo = ProcessInfo.processInfo.environment
        let isUnitTesting = envInfo["XCTestConfigurationFilePath"] != nil
        return isUnitTesting
    }

}
