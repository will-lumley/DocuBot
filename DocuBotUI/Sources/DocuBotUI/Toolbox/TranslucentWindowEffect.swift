//
//  TranslucentWindowEffect.swift
//
//
//  Created by William Lumley on 23/7/2024.
//

import SwiftUI

public extension View {

    func translucentWindowEffect() -> some View {
        TranslucentVisualView().ignoresSafeArea()
    }

}

struct TranslucentVisualView: NSViewRepresentable {

    func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.state = .active
        return view
    }

    func updateNSView(_ view: NSView, context: Context) {
        // Intentionally left blank
    }
}
