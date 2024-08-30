//
//  ChatTextEditor.ChatTextView.swift
//  DocuBot
//
//  Created by William Lumley on 29/8/2024.
//

import AppKit

class ChatTextEditor: NSView, NSTextViewDelegate {

    // MARK: - Types

    public typealias OnHeightChange = ((CGFloat) -> Void)

    // MARK: - Properties

    //The NSTextView stack
    /*------------------------------------------------------------*/
    public private(set) lazy var textStorage = NSTextStorage()
    public private(set) lazy var layoutManager = NSLayoutManager()
    public private(set) lazy var textContainer = NSTextContainer()
    public private(set) lazy var scrollview = NSScrollView()
    public private(set) lazy var textView = ChatTextView(
        frame: CGRect(), 
        textContainer: self.textContainer,
        eventDelegate: self
    )
    /*------------------------------------------------------------*/

    /// The closure that will be called when the user has indicated they want to send the message
    public var onEnterSelected: ChatTextEditorView.OnEnterSelected?

    /// The closure that will be called when we've deemed the height to change
    /// due to modified text or view/window resizing
    public var onHeightChange: OnHeightChange?

    private var previousHeight: CGFloat?
    private let maxHeight = CGFloat(250)
    private let heightPadding = CGFloat(0)

    // MARK: - Lifecycle

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }

    func setup() {
        self.textView.delegate = self
        self.configureTextView(isHorizontalScrollingEnabled: false)
        self.configureTextViewLayout()
    }

}

// MARK: - Internal

extension ChatTextEditor {

    func adjustTextViewHeight() {
        // Recalculate the height based on the current size
        let usedRect = self.layoutManager.usedRect(for: self.textContainer)

        // If the height is 0, just ignore it
        guard usedRect.height != .zero else {
            return
        }

        // Update the text container's width to match the new frame size
        self.textContainer.containerSize = CGSize(
            width: self.frame.width,
            height: CGFloat.greatestFiniteMagnitude
        )

        var height = usedRect.height + self.heightPadding
        height = min(height, self.maxHeight)

        // If our calculated height is the same as the previous one, don't
        // send an update
        if height != self.previousHeight {
            // Notify SwiftUI of the new height
            onHeightChange?(height)
        }

        print("Height: \(height)")
        self.previousHeight = height
    }

}

// MARK: - Private

private extension ChatTextEditor {

    func configureTextViewLayout() {
        self.scrollview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.scrollview)

        NSLayoutConstraint.activate([
            self.scrollview.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.scrollview.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    func configureTextView(isHorizontalScrollingEnabled: Bool) {
        let contentSize = self.scrollview.contentSize

        self.textStorage.addLayoutManager(self.layoutManager)
        self.layoutManager.addTextContainer(self.textContainer)

        if isHorizontalScrollingEnabled {
            self.textContainer.containerSize = CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
            self.textContainer.widthTracksTextView = false
        } else {
            self.textContainer.containerSize = CGSize(
                width: contentSize.width,
                height: CGFloat.greatestFiniteMagnitude
            )
            self.textContainer.widthTracksTextView = true
        }
        
        self.textView.minSize = CGSize(width: 0, height: 0)
        self.textView.maxSize = CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        self.textView.isVerticallyResizable = true
        self.textView.isHorizontallyResizable = isHorizontalScrollingEnabled
        self.textView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentSize.width,
            height: contentSize.height
        )
        
        if isHorizontalScrollingEnabled {
            textView.autoresizingMask = [.width, .height]
        }
        else {
            textView.autoresizingMask = [.width]
        }
        
        self.textView.allowsUndo = true
        
        self.scrollview.borderType = .noBorder
        self.scrollview.hasVerticalScroller = true
        self.scrollview.hasHorizontalScroller = isHorizontalScrollingEnabled
        self.scrollview.documentView = self.textView
    }

}

// MARK: - ChatTextViewEventDelegate

extension ChatTextEditor: ChatTextView.EventDelegate {

    func enterSelected() {
        // Our `TextView` has indicated that the enter key has been
        // selected.
        //
        // Our SwiftUI view `ChatTextEditorView` will have this closure set,
        // so by calling it, we're bubbling this event to our SwiftUI layer.
        //
        self.onEnterSelected?()
    }

    func recalculateHeight() {
        self.adjustTextViewHeight()
    }

}
