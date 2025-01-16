//
//  AppDelegate.swift
//  DocuBotApplication
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotService
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties

    var isTesting: Bool {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        return isUnitTesting
    }

    lazy var serviceContainer: ServiceContainer = {
        ServiceContainer(isTesting: isTesting)
    }()

    private lazy var flagService: FlagService = {
        self.serviceContainer.flagService
    }()

    // MARK: - AppDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        serviceContainer.logService.log(with: .info, "Starting application.")
    }

}
