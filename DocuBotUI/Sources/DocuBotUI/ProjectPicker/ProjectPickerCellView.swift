//
//  ProjectPickerCellView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI
import SFSafeSymbols

public struct ProjectPickerCellView: View {

    // MARK: - Properties

    @StateObject var viewModel: ProjectPickerCellViewModel

    // MARK: - View

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                    .padding([.horizontal])
                    .padding(.bottom, 2)
                    .padding(.top, 4)

                Text(viewModel.subtitle)
                    .font(.footnote)
                    .padding([.horizontal])
                     .padding(.bottom, 4)
            }

            Spacer()

            Button(action: viewModel.openButtonSelected, label: {
                Image(systemSymbol: .arrowForwardCircle)
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }

    }
}

// MARK: - Preview

#Preview {
    ProjectPickerCellView(viewModel: .mock)
}
