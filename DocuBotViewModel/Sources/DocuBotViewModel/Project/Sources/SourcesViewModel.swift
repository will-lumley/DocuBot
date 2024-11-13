//
//  SourcesViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 23/10/2024.
//

import DocuBotModel
import DocuBotService
import Foundation

public protocol SourceCellModelDelegate: AnyObject {
    func shouldShowScore() -> Bool
}

public class SourcesViewModel: DocuBotViewModel {

    // MARK: - Properties

    public let sources: [SourceCellModel]

    // MARK: - Lifecycle

    init(sources: [SourceCellModel], serviceContainer: ServiceContainer) {
        self.sources = sources
        super.init(serviceContainer: serviceContainer)
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
            ],
            serviceContainer: .mock
        )
    }

}
