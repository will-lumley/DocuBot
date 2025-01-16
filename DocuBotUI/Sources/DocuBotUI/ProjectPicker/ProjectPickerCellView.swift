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
        VStack {
            Image(systemSymbol: .booksVerticalFill)
                .resizable()
                .frame(width: 70, height: 70)

            Text(viewModel.title)
                .font(.headline)
                .padding([.horizontal])
                .padding(.bottom, 8)

            Text(viewModel.subtitle)
                .font(.footnote)
                .padding([.horizontal])
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ProjectPickerCellView(viewModel: .mock)
}
