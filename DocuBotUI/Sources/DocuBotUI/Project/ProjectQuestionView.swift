//
//  ProjectQuestionView.swift
//
//
//  Created by William Lumley on 25/8/2024.
//

import DocuBotViewModel
import SFSafeSymbols
import SwiftUI

public struct ProjectQuestionView: View {

    // MARK: - Properties

    @StateObject var viewModel: ProjectQuestionViewModel

    // MARK: - View

    public var body: some View {
        Button(action: viewModel.select, label: {
            VStack(alignment: .leading) {
                Text(viewModel.content)
                    .font(.caption2)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 75, alignment: .leading)
        })
        .buttonStyle(CapsuleButtonStyle())
        .frame(maxWidth: 300)
    }

}

struct CapsuleButtonStyle: ButtonStyle {

    // MARK: - Properties

    @State var hovered = false

    // MARK: - View

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(hovered ? .body.bold() : .body)
            .background(
                RoundedRectangle(
                    cornerSize: CGSize(width: 10, height: 10),
                    style: .continuous
                )
                .strokeBorder(self.hovered ? Color.primary.opacity(0) : Color.primary.opacity(0.2), lineWidth: 0.5)
                .foregroundColor(Color.primary)
                .background(self.hovered ? Color.primary.opacity(0.1) : Color.clear)
            )
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .onHover { hovering in
                self.hovered = hovering
            }
            .animation(.easeInOut(duration: 0.16), value: self.hovered)
            .clipShape(
                RoundedRectangle(
                    cornerSize: CGSize(width: 10, height: 10),
                    style: .continuous
                )
            )
    }
}

// MARK: - Preview

#Preview {
    ProjectQuestionView(
        viewModel: .mock
    )
        .padding()
}
