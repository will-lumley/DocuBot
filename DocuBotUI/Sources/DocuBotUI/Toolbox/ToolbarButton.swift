//
//  IconButton.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import DocuBotViewModel
import SwiftUI

struct ToolbarButton: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ToolbarButtonViewModel
    @State private var isHovered = false

    // MARK: - View

    var body: some View {
        Button(
            action: viewModel.selected,
            label: {
                Label(viewModel.name, systemSymbol: viewModel.symbol)
                    .font(Font.body.weight(.bold))
                    .imageScale(.large)
                    .foregroundStyle(self.foregroundStyle)
            }
        )
        .disabled(viewModel.isEnabled == false)
        .onHover { hovering in
            self.isHovered = hovering
        }
    }

    var foregroundStyle: some ShapeStyle {
        switch viewModel.warningState {
        case .none:
            viewModel.isEnabled ? Color.secondary : Color.secondary.opacity(0.5)
        case .warning:
            viewModel.isEnabled ? Color.yellow : Color.yellow.opacity(0.5)
        case .error:
            viewModel.isEnabled ? Color.red : Color.red.opacity(0.5)
        }
    }

}

#Preview {
    ToolbarButton(viewModel: .mock)
        .frame(width: 100, height: 100)
}
