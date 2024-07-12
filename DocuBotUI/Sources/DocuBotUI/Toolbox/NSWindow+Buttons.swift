//
//  NSWindow+Buttons.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import AppKit

public extension NSWindow {

    func disableFullScreenButton() {
        guard let button = standardWindowButton(.zoomButton) else { return }
        button.isEnabled = false
    }

}
