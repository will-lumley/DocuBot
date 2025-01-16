//
//  AppDelegate.swift
//  DocuBotApplication
//
//  Created by William Lumley on 4/7/2024.
//

import AppKit
import DocuBotService
import DocuBotToolbox
import DocuBotUI
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties

    lazy var serviceContainer: ServiceContainer = {
        ServiceContainer(isTesting: Device.isUnitTesting)
    }()

    private lazy var flagService: FlagService = {
        self.serviceContainer.flagService
    }()

    private var aboutBoxWindowController: NSWindowController?

    // MARK: - AppDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = serviceContainer.gptService
        serviceContainer.logService.log(with: .info, "Starting application.")

        NSWindow.allowsAutomaticWindowTabbing = false
    }

    // MARK: - Window Management

    @MainActor
    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [
                .closable,
                .miniaturizable,
                .titled
            ]

            let aboutView = AboutView(
                viewModel: .init(serviceContainer: serviceContainer)
            )

            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About DocuBot"
            window.contentView = NSHostingView(rootView: aboutView)
            window.center()
            aboutBoxWindowController = NSWindowController(window: window)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }

}
