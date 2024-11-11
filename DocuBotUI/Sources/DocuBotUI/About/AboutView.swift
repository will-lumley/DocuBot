//
//  AboutView.swift
//  DocuBotUI
//
//  Created by William Lumley on 11/11/2024.
//

import DocuBotViewModel
import MarkdownUI
import SwiftUI

public struct AboutView: View {

    // MARK: - Properties

    @StateObject var viewModel: AboutViewModel

    // MARK: - Lifecycle

    public init(viewModel: AboutViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        HStack {
            self.about

            Divider()
                .padding()

            self.acknowledgements
        }
        .frame(width: 500, height: 400)
    }

    private var acknowledgements: some View {
        VStack(alignment: .leading) {
            Text(viewModel.acknowledgementsTitle)
                .font(.title)
                .padding(.top)

            Text(viewModel.acknowledgementsSubtitle)
                .font(.headline)

            Spacer()

            ScrollView {
                Markdown(viewModel.acknowledgementsMarkdown)
            }
            .padding(.bottom)
        }
        .padding(.trailing)
    }

    private var about: some View {
        VStack(spacing: 0) {
            HStack {
                Image("DocuBot")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .shadow(radius: 15)

                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.title)

                    Text(viewModel.subtitle)
                        .font(.subheadline)
                }
            }

            Divider()
                .padding()

            MenuButton(viewModel: viewModel.licence)
                .padding(2)
            MenuButton(viewModel: viewModel.privacyPolicy)
                .padding(2)
        }
    }

}

// MARK: - Preview

#Preview {
    AboutView(viewModel: .mock)
}
