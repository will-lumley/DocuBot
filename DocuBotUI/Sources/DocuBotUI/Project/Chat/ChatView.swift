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

    @State var textEditorHeight = CGFloat(20)
    @FocusState private var chatTextEditorFocused: Bool

    @StateObject var viewModel: ChatViewModel

    // MARK: - View

    public var body: some View {
        VStack{
            Spacer()

            HStack(alignment: .center) {
                VStack {
                    ChatTextEditorView(
                        text: $viewModel.chatText,
                        height: $textEditorHeight,
                        onEnterSelected: viewModel.enterSelected
                    )
                    .frame(height: textEditorHeight)
                    .focused($chatTextEditorFocused)
                }
                .padding(10)
                .background(Asset.chatTextView.swiftUIColor)
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 10,
                        style: .continuous
                    )
                )
            }
        }
        .onAppear {
            self.chatTextEditorFocused = true
        }
    }

}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mock)
}
