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

    // MARK: - View

    var body: some Scene {
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
                        self.focusWelcomeWindow()
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
    }

    private func focusWelcomeWindow() {
        if let window = NSApp.windows.first(where: {
            $0.identifier?.rawValue == WelcomeView.id
        }) {
            window.makeKeyAndOrderFront(nil)

            // Bring the app to the front if needed
            NSApp.activate(ignoringOtherApps: true)
        }
    }

}
