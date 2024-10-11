//
//  ChatView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftfulLoadingIndicators
import SwiftUI

public struct ChatView: View {

    // MARK: - Properties

    @State var textEditorHeight = CGFloat(20)
    @FocusState private var chatTextEditorFocused: Bool

    @StateObject var viewModel: ChatViewModel

    // MARK: - View

    public var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        if let messages = viewModel.messages {
                            ForEach(messages) { message in
                                MessageCellView(viewModel: message)
                                    .id(message.id)
                            }

                            switch viewModel.loadingState {
                            case .loading:
                                HStack {
                                    LoadingIndicator(
                                        animation: .circleRunner,
                                        color: .white,
                                        size: .small
                                    )
                                    .padding(.leading, 4)
                                    Spacer()
                                }
                                .id(ChatViewModel.LoadingState.loading)
                            case .partial(let content):
                                PartialMessageCellView(content: content)
                                    .id(content)
                            case .none:
                                EmptyView()
                            }
                        } else {
                            EmptyView()
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 10)
                }
                .defaultScrollAnchor(.bottom)
                .onReceive(viewModel.$messages) { messages in
                    guard let lastMessage = messages?.last else {
                        return
                    }
                    DispatchQueue.main.async {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onReceive(viewModel.$loadingState) { value in
                    DispatchQueue.main.async {
                        withAnimation(.easeOut) {
                            switch value {
                            case .loading:
                                proxy.scrollTo(ChatViewModel.LoadingState.loading, anchor: .bottom)
                            case .partial(let content):
                                proxy.scrollTo(content, anchor: .bottom)
                            case .none: ()
                            }
                        }
                    }
                }
            }

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
            // When we load the ChatView, we want the TextView to be in focus
            self.chatTextEditorFocused = true
        }
    }

}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mock)
}
