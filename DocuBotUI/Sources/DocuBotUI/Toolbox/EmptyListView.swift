//
//  EmptyProjectView.swift
//
//
//  Created by William Lumley on 24/7/2024.
//

import DocuBotViewModel
import SwiftUI

struct EmptyListView: View {

    // MARK: - Properties

    let configuration: EmptyListConfiguration

    // MARK: - View

    var body: some View {
        VStack {
            Image(systemSymbol: configuration.icon)
                .resizable()
                .frame(width: 75, height: 75)
                .padding()

            Text(configuration.title)
                .font(.headline)
                .padding(.bottom, 4)
                .multilineTextAlignment(.center)

            Text(configuration.subtitle)
                .font(.subheadline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

}

// MARK: - Preview

#Preview {
    EmptyListView(configuration: .mock)
}
