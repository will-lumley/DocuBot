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
        VStack(alignment: .leading) {
            Text(viewModel.title)
                .font(.headline)
                .padding([.horizontal])
                .padding(.bottom, 2)

            Text(viewModel.subtitle)
                .font(.footnote)
                .padding([.horizontal])
                .padding(.bottom, 4)
        }
    }
}

// MARK: - Preview

#Preview {
    ProjectPickerCellView(viewModel: .mock)
}
