//
//  DocuBotApp.swift
//  DocuBot
//
//  Created by William Lumley on 3/7/2024.
//

import DocuBotUI
import DocuBotViewModel
import SwiftUI

@main
struct DocuBotApp: App {

    // MARK: - Properties

    @Environment(\.openWindow) var openWindow
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var isWelcomeViewOpen: Bool = false
    @State private var isModelViewOpen: Bool = false

    // MARK: - View

    var body: some Scene {
        // Our Settings view
        Settings {
            SettingsView(
                viewModel: .init(
                    serviceContainer: delegate.serviceContainer
                )
            )
        }

        // This is our Welcome Window
        WindowGroup(id: WelcomeView.id) {
            WelcomeView(
                viewModel: .init(serviceContainer: delegate.serviceContainer)
            )
            .onAppear {
                self.isWelcomeViewOpen = true
            }
            .onDisappear {
                self.isWelcomeViewOpen = false
            }
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
        .onChange(of: isWelcomeViewOpen) { _, newValue in
            if newValue == false {
                // If WelcomeView is closed, reset the state
                self.isWelcomeViewOpen = false
            }
        }
        .commands {
            // Our About DocuBot view
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: delegate.showAboutPanel) {
                    Text("About DocuBot")
                }
            }

            // Removing the Help menu
            CommandGroup(replacing: CommandGroupPlacement.help) { }

            // Open our Welcome View
            CommandGroup(after: .windowArrangement, addition: {
                Button("Welcome to DocuBot") {
                    // If we haven't got the welcome window open, open it
                    if self.isWelcomeViewOpen == false {
                        self.openWindow(id: WelcomeView.id)
                        self.isWelcomeViewOpen = true
                    }

                    // We already have it open, just focus it
                    else {
                        self.focusWindow(with: WelcomeView.id)
                    }
                }
                .keyboardShortcut("1", modifiers: [.command, .shift])
            })
        }

        // This is our Project window
        WindowGroup(for: ProjectViewModel.OpenWindowPackage.self) { $package in
            if let package {
                ProjectView(
                    viewModel: .init(
                        project: package.project,
                        serviceContainer: delegate.serviceContainer
                    )
                )
            }
        }
        .windowResizability(.contentSize)

        // This is our ModelManager window
        WindowGroup(id: ModelManagerView.id) {
            ModelManagerView(
                viewModel: .init(serviceContainer: delegate.serviceContainer)
            )
            .onAppear {
                self.isModelViewOpen = true
            }
            .onDisappear {
                self.isModelViewOpen = false
            }
        }
        .windowResizability(.contentSize)
        .onChange(of: isModelViewOpen) { _, newValue in
            if newValue == false {
                // If ModelView is closed, reset the state
                self.isModelViewOpen = false
            }
        }
        .commands {
            // Open our ModelManager View
            CommandGroup(after: .windowArrangement, addition: {
                Button("Model Manager") {
                    // If we haven't got the welcome window open, open it
                    if self.isModelViewOpen == false {
                        self.openWindow(id: ModelManagerView.id)
                        self.isModelViewOpen = true
                    }

                    // We already have it open, just focus it
                    else {
                        self.focusWindow(with: ModelManagerView.id)
                    }
                }
                .keyboardShortcut("2", modifiers: [.command, .shift])
            })
        }

    }

    private func focusWindow(with id: String) {
        if let window = NSApp.windows.first(where: {
            $0.identifier?.rawValue == id
        }) {
            window.makeKeyAndOrderFront(nil)

            // Bring the app to the front if needed
            NSApp.activate(ignoringOtherApps: true)
        }
    }

}
