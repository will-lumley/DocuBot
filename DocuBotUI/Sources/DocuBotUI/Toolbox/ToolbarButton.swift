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
                if let hoverSymbol = viewModel.hoverSymbol, self.isHovered {
                    VStack {
                        Image(systemSymbol: hoverSymbol)
                            .font(Font.body.weight(.bold))
                            .imageScale(.large)
                        if let name = viewModel.name {
                            Text(name)
                        }
                    }
                } else {
                    VStack {
                        Image(systemSymbol: viewModel.symbol)
                            .font(Font.body.weight(.bold))
                            .imageScale(.large)
                            .foregroundStyle(self.foregroundStyle)

                        if let name = viewModel.name {
                            Text(name)
                        }
                    }
                }
            }
        )
        .disabled(viewModel.isEnabled == false)
        .onHover { hovering in
            self.isHovered = hovering
        }
    }

    var foregroundStyle: some ShapeStyle {
        switch self.viewModel.warningState {
        case .none:
            Color.secondary
        case .warning:
            Color.yellow
        }
    }

}

#Preview {
    ToolbarButton(viewModel: .mock)
        .frame(width: 100, height: 100)
}
