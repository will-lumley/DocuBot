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

    // MARK: - View

    var body: some Scene {
        // This is our Welcome Window
        WindowGroup(id: WelcomeView.id) {
            WelcomeView(
                viewModel: .init(
                    onCloseWindow: {
                        NSApplication.shared.windows.first?.close()
                    },
                    serviceContainer: delegate.serviceContainer
                )
            )
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            // Open our Welcome View
            CommandGroup(after: .windowArrangement, addition: {
                Button("Welcome to DocuBot") {
                    self.openWindow(id: WelcomeView.id)
                }
                .keyboardShortcut("1", modifiers: [.command, .shift])
            })
        }

        // This is our CreateProject window
        WindowGroup(for: CreateProjectViewModel.OpenWindowPackage.self) { _ in
            CreateProjectView(
                viewModel: .init(
                    serviceContainer: delegate.serviceContainer
                )
            )
        }
        .windowResizability(.contentSize)

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

}
