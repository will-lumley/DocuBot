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

public class SourceCellModel: ObservableObject {

    // MARK: - Properties

    private let document: Document
    public let score: Float
    public var delegate: SourceCellModelDelegate?

    // MARK: - Lifecycle

    public init(
        document: Document,
        score: Float,
        delegate: SourceCellModelDelegate? = nil
    ) {
        self.document = document
        self.score = score
        self.delegate = delegate
    }

}

// MARK: - Public

public extension SourceCellModel {

    var url: URL {
        self.document.url
    }

    var title: String {
        self.document.url.lastPathComponent
    }

    var subtitle: String {
        self.document.url.path()
    }

    var scoreDescription: String {
        let percent = Int(self.score * 100)
        return "\(percent)%"
    }

    var shouldShowScore: Bool {
        self.delegate?.shouldShowScore() ?? false
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

private extension SourceCellModel {

    func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([document.url])
    }

}

// MARK: - Hashable

extension SourceCellModel: Hashable {

    public static func == (
        lhs: SourceCellModel,
        rhs: SourceCellModel
    ) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.document)
    }

}

// MARK: - Identifiable

extension SourceCellModel: Identifiable {

    public var id: Int64 {
        self.document.id ?? -1
    }

}
