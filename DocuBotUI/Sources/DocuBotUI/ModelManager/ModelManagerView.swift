//
//  ModelManagerView.swift
//  DocuBotUI
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotViewModel
import SwiftUI

public struct ModelManagerView: View {

    // MARK: - Properties

    @StateObject public var viewModel: ModelManagerViewModel
    @State var showFileImporter = false

    public static let id = "ModelView"

    // MARK: - Lifecycle

    public init(viewModel: ModelManagerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - View

    public var body: some View {
        VStack(spacing: 0) {
            List(viewModel.models) { model in
                ModelCellView(viewModel: model)
            }
            self.bottomToolbar
        }
        .navigationTitle(viewModel.windowTitle)
        .frame(width: 500, height: 300)
    }

    private var bottomToolbar: some View {
      VStack(spacing: 0) {
          Rectangle()
              .frame(maxWidth: .infinity, maxHeight: 1)
              .foregroundColor(Color(NSColor.gridColor))
          
          HStack {
              Button(action: {
                  showFileImporter = true
              }) {
                  Image(systemName: "plus")
                      .padding(.horizontal, 6)
                      .frame(maxHeight: .infinity)
              }
              .frame(maxHeight: .infinity)
              .padding(.leading, 10)
              .buttonStyle(.borderless)
              .help("Add custom model (.gguf file)")
              .background(Color.white.opacity(0.0001))
              .fileImporter(
                  isPresented: $showFileImporter,
                  allowedContentTypes: [.data],
                  allowsMultipleSelection: true,
                  onCompletion: { foo in

                  }
              )
              Button(action: {
                
              }) {
                  Image(systemName: "minus").padding(.horizontal, 6)
                      .frame(maxHeight: .infinity)
              }
              .frame(maxHeight: .infinity)
              .buttonStyle(.borderless)

              Spacer()
              Button("Select") {
            
          }
            .keyboardShortcut(.return, modifiers: [])
            .frame(width: 0)
            .hidden()
          Button("Done") {
            
          }.padding(.horizontal, 10).keyboardShortcut(.escape)
        }
          .frame(maxWidth: .infinity, maxHeight: 27, alignment: .leading)
      }
        .background(Material.bar)
    }

}
