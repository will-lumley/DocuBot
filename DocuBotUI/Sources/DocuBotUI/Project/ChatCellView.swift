//
//  ChatCellView.swift
//
//
//  Created by William Lumley on 26/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct ChatCellView: View {

    // MARK: - Properties

    @StateObject var viewModel: ChatCellViewModel

    // MARK: - Lifecycle

    public init(viewModel: ChatCellViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        switch viewModel.state {
        case .display:
            Text(viewModel.title)
        case .rename:
            TextField("", text: $viewModel.renameTitle)
        }
    }

}

// MARK: - Preview

#Preview {
    ChatCellView(viewModel: .mock)
}
