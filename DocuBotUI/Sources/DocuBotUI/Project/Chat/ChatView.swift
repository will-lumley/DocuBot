//
//  ChatView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct ChatView: View {

    // MARK: - Properties

    @StateObject var viewModel: ChatViewModel

    // MARK: - View

    public var body: some View {
        Text(viewModel.foo)
    }

}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mock)
}
