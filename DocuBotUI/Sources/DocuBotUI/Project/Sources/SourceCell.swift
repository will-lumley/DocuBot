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

public struct SourceCell: View {

    // MARK: - Properties

    @State private var quickLookPreview = false
    @StateObject var viewModel: SourceCellModel

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            if viewModel.shouldShowScore {
                VStack(spacing: 0) {
                    ProgressView(value: viewModel.score, total: 1.0)
                        .progressViewStyle(.circular)
                        .scaleEffect(-0.5)

                    Text(viewModel.scoreDescription)
                        .font(.footnote)
                }
                .padding(.trailing, 6)
            } else {
                Image(systemName: "doc.text.fill")
                    .padding(.trailing, 6)
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
    SourceCell(viewModel: .mock)
}
