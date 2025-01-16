//
//  SourcesView.swift
//  DocuBotUI
//
//  Created by William Lumley on 24/10/2024.
//

import DocuBotViewModel
import SwiftUI

public struct SourcesView: View {

    // MARK: - Properties

    @StateObject var viewModel: SourcesViewModel

    // MARK: - View

    public var body: some View {
        VStack {
            List(viewModel.sources) { source in
                SourceCell(viewModel: source)
            }
        }
    }

}
// MARK: - Preview

#Preview {
    SourcesView(viewModel: .mock)
}

public extension SourcesViewModel {

    static var mock: SourcesViewModel {
        .init(
            sources: [
                .init(
                    document: .init(
                        url: .desktopDirectory,
                        fileFormat: .md,
                        content: "Hello, there!",
                        checksum: "123",
                        projectID: 1,
                        embeddings: nil,
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    score: 0.65
                ),
                .init(
                    document: .init(
                        url: .desktopDirectory,
                        fileFormat: .md,
                        content: "Hello, there!",
                        checksum: "123",
                        projectID: 1,
                        embeddings: nil,
                        createdAt: .now,
                        updatedAt: .now
                    ),
                    score: 0.65
                )
            ],
            serviceContainer: .mock
        )
    }

}
