//
//  CreateProjectView.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import DocuBotViewModel
import SwiftUI

public struct CreateProjectView: View {

    // MARK: - Properties

    @StateObject var viewModel: CreateProjectViewModel

    // MARK: - Lifecycle

    public init(viewModel: CreateProjectViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.projectDirectoryTitle)
                    .font(.headline)
                    .bold()
                    .padding([.horizontal, .top])
                    .padding(.bottom, 2)

                Text(viewModel.projectDirectory)
                    .font(.body)
                    .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(viewModel.windowTitle)
        .frame(width: 650, height: 400)
    }

}

// MARK: - Preview

#Preview {
    CreateProjectView(viewModel: .mock)
}

