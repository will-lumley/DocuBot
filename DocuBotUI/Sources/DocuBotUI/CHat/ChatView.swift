//
//  ChatView.swift
//  
//
//  Created by William Lumley on 3/7/2024.
//

import DocuBotViewModel
import SwiftUI

struct ChatView: View {

    // MARK: - Properties

    @StateObject var viewModel: ChatViewModel

    // MARK: - View

    var body: some View {
        Text("Hello, World!")
    }

}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mock)
}
