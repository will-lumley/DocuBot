//
//  HelpButton.swift
//
//
//  Created by William Lumley on 24/7/2024.
//

import SwiftUI

struct HelpButton: View {

    // MARK: - Types

    typealias OnSelect = () -> Void

    // MARK: - Properties

    var onSelect: OnSelect

    var body: some View {
        Button(
            action: onSelect,
            label: {
                ZStack {
                    Circle()
                        .strokeBorder(Color.controlShadowColor, lineWidth: 0.5)
                        .background(
                            Circle()
                                .foregroundColor(Color.controlColor)
                        )
                        .shadow(
                            color: Color.controlShadowColor.opacity(0.3),
                            radius: 1
                        )
                        .frame(width: 20, height: 20)

                    Text("?")
                        .font(.system(size: 15, weight: .medium))
                }
            }
        )
        .buttonStyle(PlainButtonStyle())
    }

}

// MARK: - Color

private extension Color {

    static var controlColor: Color {
        Color(NSColor.controlColor)
    }

    static var controlShadowColor: Color {
        Color(NSColor.separatorColor)
    }

}
