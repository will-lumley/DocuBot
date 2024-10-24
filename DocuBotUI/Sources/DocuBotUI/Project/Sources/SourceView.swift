//
//  SourceView.swift
//  DocuBotUI
//
//  Created by William Lumley on 18/10/2024.
//

import AppKit
import DocuBotViewModel
import Quartz
import QuickLook
import QuickLookThumbnailing
import SFSafeSymbols
import SwiftUI

public struct SourceView: View {

    // MARK: - Properties

    @State private var quickLookPreview = false
    @StateObject var viewModel: SourceViewModel

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "doc.text.fill")
                .padding(.leading, 4)

            VStack {
                ProgressView(value: viewModel.score, total: 1.0)
                    .progressViewStyle(.circular)
                    .scaleEffect(-0.5)
            }

            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.subheadline)
                    .bold()

                Text(viewModel.subtitle)
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .padding([.vertical, .trailing], 4)

            .contextMenu {
                ForEach(viewModel.contextMenuConfigurations) { configuration in
                    Button(configuration.text, action: configuration.onSelect)
                }
            }

        }
    }

}

// MARK: - Preview

#Preview {
    SourceView(viewModel: .mock)
}
