//
//  ProjectPickerView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI

public struct ProjectPickerView: View {

    // MARK: - Properties

    @StateObject var viewModel: ProjectPickerViewModel
    @State private var dragOffset = CGSize.zero
    @State private var initialLocation: CGPoint = .zero

    // MARK: - Lifecycle

    public init(viewModel: ProjectPickerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        ZStack(alignment: .topLeading) {

            HStack(spacing: 0) {
                VStack {
                    Image("DocuBot")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .shadow(radius: 15)

                    Text(viewModel.title)
                        .font(.title)
                        .padding(.top)
                        .padding(.bottom, 4)

                    Text(viewModel.subtitle1)
                        .font(.subheadline)

                    Text(viewModel.subtitle2)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // This background makes the view translucent and pretty
                .background(
                    Rectangle()
                        .translucentWindowEffect()
                )

                // This gesture allows this view to drag the window around
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if initialLocation == .zero {
                                initialLocation = value.startLocation
                            }
                            self.moveWindow(by: value.translation)
                        }
                        .onEnded { _ in
                            initialLocation = .zero
                        }
                )

                VStack {
                    Text("THERE")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue)
            }
            .frame(width: 500, height: 400)

            IconButton(viewModel: viewModel.closeButton)
                .padding(.leading, 8)
                .padding(.top, -16)
        }
    }

    private func moveWindow(by offset: CGSize) {
        if let window = NSApplication.shared.windows.first {
            var newFrame = window.frame
            newFrame.origin.x += offset.width
            newFrame.origin.y -= offset.height
            window.setFrame(newFrame, display: true)
        }
    }

}

// MARK: - Preview

#Preview {
    ProjectPickerView(viewModel: .mock)
}
