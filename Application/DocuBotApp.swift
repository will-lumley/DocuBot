//
//  DocuBotApp.swift
//  DocuBot
//
//  Created by William Lumley on 3/7/2024.
//

import DocuBotUI
import SwiftUI

@main
struct DocuBotApp: App {

    // MARK: - Properties

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // MARK: - View

    var body: some Scene {
        WindowGroup {
            ProjectPickerView(
                viewModel: .init(
                    onCloseWindow: {
                        NSApplication.shared.windows.first?.close()
                    },
                    serviceContainer: delegate.serviceContainer
                )
            )
            .onAppear {
                if let window = NSApplication.shared.windows.first {
                    window.standardWindowButton(.closeButton)?.superview?.isHidden = true
                    window.titlebarAppearsTransparent = true
               }
            }
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
