//
//  WelcomeView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI

public struct WelcomeView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.openWindow) var openWindow

    @StateObject var viewModel: WelcomeViewModel
    @State private var dragOffset = CGSize.zero
    @State private var initialLocation: CGPoint = .zero

    public static let id = "WelcomeView"

    // MARK: - Lifecycle

    public init(viewModel: WelcomeViewModel) {
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

        // Listen to our OnDismiss listener
        .onReceive(viewModel.onDismiss) { _ in
            self.dismiss()
        }

        .confirmationDialog(
            viewModel.deleteProjectConfirmationDialog.title,
            isPresented: $viewModel.deleteProjectConfirmationDialogPresented,
            actions: {
                ForEach(viewModel.deleteProjectConfirmationDialog.buttons) { button in
                    Button(button.title, role: button.role.buttonRole, action: button.action)
                }
            }
        )
        .dialogIcon(.init(systemSymbol: .trashCircleFill))
        .onAppear {
            if let window = NSApplication.shared.windows.last {
                window.standardWindowButton(.closeButton)?.superview?.isHidden = true
                window.titlebarAppearsTransparent = true
            }
        }
    }

}

// MARK: - Private

private extension WelcomeView {

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

            MenuButton(viewModel: viewModel.newProjectButton)
                .keyboardShortcut("n", modifiers: .command)
            MenuButton(viewModel: viewModel.openModelManager)
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

        // Listen to our OnDismiss listener
        .onReceive(viewModel.onDismiss) { _ in
            self.dismiss()
        }

        // Listen to our OnOpen listener
        .onReceive(viewModel.onOpen) { open in
            switch open {
            case .modelManager:
                self.openWindow(id: ModelManagerView.id)
            case .project(let package):
                self.openWindow(value: package)
            }
        }

        // Listen to our Alert
        .alert(item: $viewModel.alertConfiguration) { configuration in
            Alert(
                title: Text(configuration.title),
                message: Text(configuration.message)
            )
        }

        // Listen to our CreateProject ViewModel
        .sheet(item: $viewModel.configureProjectViewModel) { viewModel in
            ConfigureProjectView(viewModel: viewModel)
        }

    }

    var projectListView: some View {
        VStack {
            switch viewModel.listState {
            case .none:
                EmptyView()
            case .listProjects(let projects):
                List(projects) { project in
                    WelcomeProjectCellView(viewModel: project)
                        .contextMenu {
                            ForEach(viewModel.contextMenuConfigurations(for: project)) { configuration in
                                Button(configuration.text, action: configuration.onSelect)
                            }
                        }
                }
                // Yucky dirty hack to compensate for the lack of toolbar
                .padding(.top, -24)
            case .noProject(let configuration):
                EmptyListView(configuration: configuration)
            case .noModel(let configuration):
                EmptyListView(configuration: configuration)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func moveWindow(by offset: CGSize) {
        if let window = NSApp.windows.first(where: {
            $0.identifier?.rawValue.contains(WelcomeView.id) ?? false
        }) {
            var newFrame = window.frame
            newFrame.origin.x += offset.width
            newFrame.origin.y -= offset.height
            window.setFrame(newFrame, display: true)
        }
    }
}

// MARK: - Preview

#Preview {
    WelcomeView(viewModel: .mock)
}
