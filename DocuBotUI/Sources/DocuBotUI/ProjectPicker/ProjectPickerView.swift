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
                welcomeView
                projectListView
            }
            .frame(width: 650, height: 400)

            IconButton(viewModel: viewModel.closeButton)
                .padding(.leading, 12)
                .padding(.top, -16)
        }
    }

}

// MARK: - Private

private extension ProjectPickerView {

    var welcomeView: some View {
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

            Divider()
                .padding()

            MenuButton(viewModel: viewModel.loadNewProjectButton)
            MenuButton(viewModel: viewModel.viewSourceCodeButton)
            MenuButton(viewModel: viewModel.emailDeveloper)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        // This background makes the view translucent and pretty
        .background(
            Rectangle()
                .translucentWindowEffect()
        )

        // This gesture allows this view to drag the window around via this view
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
    }

    var projectListView: some View {
        VStack {
            if viewModel.projectCellViewModels.isEmpty {
                EmptyListView(configuration: viewModel.emptyProjectConfiguration)
            } else {
                List(
                    viewModel.projectCellViewModels,
                    selection: Binding(
                        get: { viewModel.selectedProject },
                        set: {
                            viewModel.selectedProject = $0
                        }
                    )
                ) { cellViewModel in
                    ProjectPickerCellView(viewModel: cellViewModel)
                }
                .padding(.top, -24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func moveWindow(by offset: CGSize) {
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
