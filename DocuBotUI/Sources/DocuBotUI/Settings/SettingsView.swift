//
//  SettingsView.swift
//  DocuBotUI
//
//  Created by William Lumley on 11/11/2024.
//

import DocuBotViewModel
import SwiftUI

public struct SettingsView: View {

    // MARK: - Properties

    @StateObject public var viewModel: SettingsViewModel
    @State private var selection: SettingsSection? = .general

    // MARK: - Lifecycle

    public init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: SettingsSection.general) {
                    Label("General", systemImage: "gear")
                }
                NavigationLink(value: SettingsSection.accounts) {
                    Label("Accounts", systemImage: "person.crop.circle")
                }
                NavigationLink(value: SettingsSection.advanced) {
                    Label("Advanced", systemImage: "gearshape")
                }
            }
            .navigationTitle("Settings")
        } detail: {
            if let selection = selection {
                switch selection {
                case .general:
                    GeneralSettingsView()
                case .accounts:
                    AccountsSettingsView()
                case .advanced:
                    AdvancedSettingsView()
                }
            } else {
                Text("Select a setting from the sidebar.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    enum SettingsSection: Hashable {
        case general, accounts, advanced
    }

    struct GeneralSettingsView: View {
        var body: some View {
            Text("General Settings")
            // Add content for General settings here
        }
    }

    struct AccountsSettingsView: View {
        var body: some View {
            Text("Accounts Settings")
            // Add content for Accounts settings here
        }
    }

    struct AdvancedSettingsView: View {
        var body: some View {
            Text("Advanced Settings")
            // Add content for Advanced settings here
        }
    }

}
