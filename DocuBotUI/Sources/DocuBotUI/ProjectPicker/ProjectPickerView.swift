//
//  ProjectPickerView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI

public struct ProjectPickerView: View {

    // MARK: - Properties

    @StateObject var viewModel: ProjectPickerViewModel

    // MARK: - Lifecycle

    public init(viewModel: ProjectPickerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        Text("Hello, World!")
            .frame(width: 550, height: 550)
    }
}

// MARK: - Preview

#Preview {
    ProjectPickerView(viewModel: .mock)
}
