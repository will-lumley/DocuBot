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
                .aspectRatio(contentMode: .fit)
                .frame(height: 75)
                .padding()

            Text(configuration.title)
                .font(.headline)
                .padding(.bottom, 4)
                .multilineTextAlignment(.center)

            Text(configuration.subtitle)
                .font(.subheadline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .lineLimit(10)

            if let action = configuration.action {
                if let secondaryTitle = action.secondaryTitle {
                    Button(
                        action: action.onSelect,
                        label: {
                            HStack {
                                Text(action.title)
                                Text(secondaryTitle)
                                    .foregroundStyle(.white.opacity(0.75))
                            }
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top)
                } else {
                    Button(action.title, action: action.onSelect)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.top)
                }
            }
        }
        .padding()
    }

}

// MARK: - Preview

#Preview {
    EmptyListView(configuration: .mock)
        .frame(width: 200, height: 400)
}
