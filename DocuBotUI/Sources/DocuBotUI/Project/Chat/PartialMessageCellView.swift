//
//  PartialMessageCellView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import AppKit
import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct PartialMessageCellView: View {

    // MARK: - Properties

    @State var content: String

    // MARK: - View

    public var body: some View {
        HStack {
            Text(self.content)
                .font(.body)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(Color.clear)
                )
            Spacer()
        }
    }

}

// MARK: - Preview

#Preview {
    WelcomeProjectCellView(viewModel: .mock)
}
