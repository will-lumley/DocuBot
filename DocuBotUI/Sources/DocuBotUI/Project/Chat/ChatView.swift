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
    @FocusState private var isFocused: Bool

    @StateObject var viewModel: ChatViewModel

    // MARK: - View

    public var body: some View {
        VStack{
            Spacer()
            
            HStack(alignment: .center) {
                VStack {
                    ZStack(alignment: .leading) {
                        Text(viewModel.text)
                            .font(.system(.body))
                            .foregroundColor(.clear)
                            .background(
                                GeometryReader {
                                    Color.clear.preference(
                                        key: ViewHeightKey.self,
                                        value: $0.frame(in: .local).size.height
                                    )
                                }
                            )

                        TextEditor(text: $viewModel.text)
                            .frame(height: textEditorHeight)
                            .frame(minHeight: 22)
                            .cornerRadius(10.0)
                            .font(.body)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .focusable()
                            .focused($isFocused)
                            .onChange(of: viewModel.text) {
                                if viewModel.text.last == "\n" {
                                    print("ENTER PRESSED")
                                }
                            }
                            .onKeyPress(keys: [.return]) { press in
                                print("Received \(press.characters)")
                                return .handled
                            }
                            .onAppear {
                                isFocused = true
                            }
                    }
                    .onPreferenceChange(ViewHeightKey.self) {
                        textEditorHeight = $0
                    }
                }
                .padding(10)
                .background(.background)
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
    }

}

// MARK: - Preview

#Preview {
    ChatView(viewModel: .mock)
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

