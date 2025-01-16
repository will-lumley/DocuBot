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

    @ObservedObject var viewModel: IconButtonViewModel
    @State private var isHovered = false

    // MARK: - View

    var body: some View {
        Button(
            action: viewModel.selected,
            label: {
                if let hoverSymbol = viewModel.hoverSymbol, self.isHovered {
                    Image(systemSymbol: hoverSymbol)
                        .font(Font.body.weight(.bold))
                        .imageScale(.large)
                } else {
                    Image(systemSymbol: viewModel.symbol)
                        .font(Font.body.weight(.bold))
                        .imageScale(.large)
                }
            }
        )
        .disabled(viewModel.isEnabled == false)
        .onHover { hovering in
            self.isHovered = hovering
        }
    }

}

#Preview {
    ToolbarButton(viewModel: .mock)
        .frame(width: 100, height: 100)
}
