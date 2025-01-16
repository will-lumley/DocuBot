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

    /// The singular instance of `ServiceContainer` that's used throughout our
    /// applications lifecycle.
    lazy var serviceContainer: ServiceContainer = {
        ServiceContainer(isTesting: Device.isUnitTesting)
    }()

    /// This `WindowController` manages the window for our `AboutView`
    private var aboutBoxWindowController: NSWindowController?

    /// This is where we store, retrieve, and create our `ProjectViewModel`s through
    lazy var projectViewModelStore: ProjectViewModelStore = {
        .init(serviceContainer: self.serviceContainer)
    }()

    // MARK: - AppDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
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
