//
//  SourcesViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 23/10/2024.
//

import DocuBotModel
import DocuBotService
import Foundation

public class SourcesViewModel: ObservableObject {

    // MARK: - Properties

    public let sources: [SourceViewModel]

    // MARK: - Lifecycle

    init(sources: [SourceViewModel]) {
        self.sources = sources
    }

}

// MARK: - Identifiable

extension SourcesViewModel: Identifiable {

    public var id: Int64 {
        self.sources
            .map(\.id)
            .reduce(0, +)
    }

}

// MARK: - Mock

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
            ]
        )
    }

}
