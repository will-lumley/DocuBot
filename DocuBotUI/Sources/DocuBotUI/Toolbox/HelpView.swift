//
//  HelpView.swift
//  DocuBotUI
//
//  Created by William Lumley on 15/10/2024.
//

import DocuBotViewModel
import SwiftUI

struct HelpView: View {

    // MARK: - Properties

    let configuration: HelpConfiguration

    // MARK: - View

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(configuration.title)
                        .font(.title)
                        .bold()
                        .padding()

                    Spacer()

                    IconButton(viewModel: configuration.closeButton)
                        .padding(.trailing)
                        .padding(.top, -8)
                }

                Text(configuration.content)
                    .font(.body)
                    .padding([.horizontal, .bottom])
            }
        }
    }

}

// MARK: - Preview

#Preview {
    HelpView(configuration: .mock)
}
