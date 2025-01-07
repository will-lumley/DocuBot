//
//  Device.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 12/10/2024.
//

import Foundation

/// A utility struct providing information about the app's version, build number, and testing environment.
public struct Device {

    /// The app's version number.
    ///
    /// This property retrieves the `CFBundleShortVersionString` from the app's `Info.plist`.
    /// If the version number is unavailable, it defaults to `"1"`.
    ///
    /// - Returns: A `String` representing the app's version number.
    public static var versionNumber: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1"
    }

    /// The app's build number.
    ///
    /// This property retrieves the `CFBundleVersion` from the app's `Info.plist`.
    /// If the build number is unavailable, it defaults to `"1.0"`.
    ///
    /// - Returns: A `String` representing the app's build number.
    public static var buildNumber: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "1.0"
    }

    /// A Boolean value indicating whether the app is running in a unit testing environment.
    ///
    /// This property checks the `XCTestConfigurationFilePath` key in the process
    /// environment to determine if the app is being executed under unit tests.
    ///
    /// - Returns: `true` if the app is running in a unit testing environment; otherwise, `false`.
    public static var isUnitTesting: Bool {
        let envInfo = ProcessInfo.processInfo.environment
        let isUnitTesting = envInfo["XCTestConfigurationFilePath"] != nil
        return isUnitTesting
    }

}
