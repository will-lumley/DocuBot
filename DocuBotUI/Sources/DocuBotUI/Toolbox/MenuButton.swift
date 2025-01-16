//
//  MenuButton.swift
//
//
//  Created by William Lumley on 28/4/2024.
//

import DocuBotViewModel
import SwiftUI

struct MenuButton: View {

    // MARK: - Properties

    @ObservedObject var viewModel: MenuButtonViewModel
    @State private var isHovered = false

    // MARK: - View

    var body: some View {
        Button(viewModel.text, action: viewModel.selected)
            .buttonStyle(BorderlessButtonStyle())
            .disabled(viewModel.isEnabled == false)
            .onHover { hovering in
                self.isHovered = hovering
            }
    }

}

#Preview {
    IconButton(viewModel: .mock )
        .frame(width: 100, height: 100)
}
