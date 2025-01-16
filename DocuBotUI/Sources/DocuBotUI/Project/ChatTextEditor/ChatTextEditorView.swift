//
//  ChatTextEditor.ChatTextView.swift
//  DocuBot
//
//  Created by William Lumley on 29/8/2024.
//

import SwiftUI

struct ChatTextEditorView: NSViewRepresentable {

    // MARK: - Types

    public typealias OnTextChanged = ((String) -> Void)
    public typealias OnEnterSelected = (() -> Void)

    // MARK: - Properties

    @Binding var text: String
    @Binding var height: CGFloat

    // This will be connected to the `ChatTextEditor` view's
    // `onEnterSelected`, so by connecting this closure we can allow
    // this event to be listened directly within our SwiftUI view
    var onEnterSelected: OnEnterSelected

    private let maxHeight = CGFloat(25)

    // MARK: - NSViewRepresentable

    func makeNSView(context: Context) -> ChatTextEditor {
        let textEditor = ChatTextEditor()

        textEditor.onEnterSelected = self.onEnterSelected
        textEditor.onHeightChange = { newHeight in
            DispatchQueue.main.async {
                self.height = newHeight
            }
        }
        textEditor.onTextChange = { newText in
            DispatchQueue.main.async {
                self.text = newText
            }
        }
        return textEditor
    }

    func updateNSView(_ view: ChatTextEditor, context: Context) {
        DispatchQueue.main.async {
            // The Binding<String> may have changed, let's re-apply
            if view.text != self.text {
                view.text = self.text
            }

            // The window may have been resized, let's re-adjust
            view.adjustTextViewHeight()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject {
        var parent: ChatTextEditorView

        init(_ parent: ChatTextEditorView) {
            self.parent = parent
        }

    }

}
