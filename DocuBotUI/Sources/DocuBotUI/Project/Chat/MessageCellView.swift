//
//  MessageCellView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI
import SFSafeSymbols

public struct MessageCellView: View {

    // MARK: - Properties

    @StateObject var viewModel: MessageCellViewModel

    // MARK: - View

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("")
                    .font(.body)
                    .padding([.horizontal])
                    .padding(.bottom, 2)
                    .padding(.top, 4)
            }
        }

    }
}

// MARK: - Preview

#Preview {
    WelcomeProjectCellView(viewModel: .mock)
}
