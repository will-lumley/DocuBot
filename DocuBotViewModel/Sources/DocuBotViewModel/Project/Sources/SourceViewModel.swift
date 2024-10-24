//
//  SourceViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 23/10/2024.
//

// Having to import AppKit makes me very sad, but necessary to open the URL
import AppKit
import DocuBotModel
import DocuBotService
import Foundation

public class SourceViewModel: ObservableObject {

    // MARK: - Properties

    private let document: Document
    public let score: Float

    // MARK: - Lifecycle

    init(document: Document, score: Float) {
        self.document = document
        self.score = score
    }

}

// MARK: - Public

public extension SourceViewModel {

    var url: URL {
        self.document.url
    }

    var title: String {
        self.document.url.lastPathComponent
    }

    var subtitle: String {
        self.document.url.path()
    }

    var contextMenuConfigurations: [ContextMenuConfiguration] {
        return [
            .init(text: L10n.Generics.showInFinder) {
                self.showInFinder()
            }
        ]
    }

}

// MARK: - Private

private extension SourceViewModel {

    func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([document.url])
    }

}

// MARK: - Identifiable

extension SourceViewModel: Identifiable {

    public var id: Int64 {
        self.document.id ?? -1
    }

}

// MARK: - Mock

public extension SourceViewModel {

    static var mock: SourceViewModel {
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
    }

}
