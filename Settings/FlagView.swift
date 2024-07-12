//
//  FlagView.swift
//  Settings
//
//  Created by William Lumley on 10/7/2023.
//

import DocuBotService
import SwiftUI
import Vexil
import Vexillographer

struct FlagView: View {

    // MARK: - Properties

    let serviceContainer: ServiceContainer

    // MARK: - View

    var body: some View {
        NavigationView {

            Form {
                Vexillographer(
                    flagPole: serviceContainer.flagService.appFlags,
                    source: serviceContainer.flagService.source
                )
            }
            .navigationTitle("Flags")

        }
    }

}

// MARK: - Preview

#Preview {
    FlagView(serviceContainer: .mock)
}
