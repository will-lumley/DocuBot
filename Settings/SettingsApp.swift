//
//  SettingsApp.swift
//  Settings
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotService
import SwiftUI

@main
struct SettingsApp: App {

    // MARK: - Properties

    private let serviceContainer = ServiceContainer()

    // MARK: - View

    var body: some Scene {
        WindowGroup {
            FlagView(serviceContainer: serviceContainer)
        }
    }

}
