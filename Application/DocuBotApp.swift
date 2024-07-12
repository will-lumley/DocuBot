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
                viewModel: .init(foo: "foo")
            )
        }
        .windowResizability(.contentSize)
    }
}
