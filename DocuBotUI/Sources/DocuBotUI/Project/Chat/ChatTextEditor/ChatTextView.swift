//
//  ChatTextView.swift
//  DocuBot
//
//  Created by William Lumley on 29/8/2024.
//

import AppKit

class ChatTextView: NSTextView {

    // MARK: - Types

    @MainActor
    protocol EventDelegate {
        func textChanged()
        func recalculateHeight()
        func enterSelected()
    }

    // MARK: - Properties

    public private(set) var shiftHeldDown = false
    public var eventDelegate: EventDelegate?

    // MARK: - Lifecycle

    init(
        frame frameRect: NSRect,
        textContainer container: NSTextContainer?,
        eventDelegate: EventDelegate
    ) {
        super.init(frame: frameRect, textContainer: container)
        self.eventDelegate = eventDelegate
        self.setup()
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    private func setup() {
        self.usesAdaptiveColorMappingForDarkAppearance = true
        self.backgroundColor = Asset.chatTextView.color

        self.isRichText = false
        self.isEditable = true
        self.font = .systemFont(ofSize: 14)
    }

    override func flagsChanged(with event: NSEvent) {
        self.shiftHeldDown = event.modifierFlags.contains(.shift)
        super.flagsChanged(with: event)
    }

    override func shouldChangeText(
        in affectedCharRange: NSRange,
        replacementString: String?
    ) -> Bool {
        // The user has selected the `return` key
        if replacementString == "\n" {
            // Are they holding down the shift key?
            if self.shiftHeldDown {
                // They are, so we treat it like a regular enter
                // after we readjust the height
                self.eventDelegate?.recalculateHeight()
                return true
            }

            // This is a regular `return` key press
            else {
                // Tell the `eventDelegate` that we've selected the enter key
                self.eventDelegate?.enterSelected()
                return false
            }
        }

        return true
    }

    override func didChangeText() {
        super.didChangeText()
        self.eventDelegate?.textChanged()
        self.eventDelegate?.recalculateHeight()
    }

}
