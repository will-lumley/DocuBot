//
//  SourceCellModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 23/10/2024.
//

// Having to import AppKit makes me very sad, but necessary to open the URL
import AppKit
import DocuBotModel
import DocuBotService
import Foundation

/// A ViewModel representing a source document in the DocuBot application, including metadata and actions.
public class SourceCellModel: ObservableObject {

    // MARK: - Properties

    /// The document associated with the source cell.
    private let document: Document

    /// The relevance score of the document.
    public let score: Float

    /// An optional delegate for handling interactions with the source cell.
    public var delegate: SourceCellModelDelegate?

    // MARK: - Lifecycle

    /// Initializes a new `SourceCellModel`.
    ///
    /// - Parameters:
    ///   - document: The `Document` instance associated with the cell.
    ///   - score: The relevance score of the document.
    ///   - delegate: An optional delegate for handling interactions. Defaults to `nil`.
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

    /// The URL of the associated document.
    var url: URL {
        self.document.url
    }

    /// The title of the document, derived from its file name.
    var title: String {
        self.document.url.lastPathComponent
    }

    /// The subtitle of the document, typically its full path.
    var subtitle: String {
        self.document.url.path()
    }

    /// A textual description of the document's score as a percentage.
    var scoreDescription: String {
        let percent = Int(self.score * 100)
        return "\(percent)%"
    }

    /// A flag indicating whether the score should be displayed.
    var shouldShowScore: Bool {
        self.delegate?.shouldShowScore() ?? false
    }

    /// The context menu configurations for the source cell.
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

    /// Opens the associated document in Finder.
    func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([document.url])
    }

}

// MARK: - Hashable

extension SourceCellModel: Hashable {

    /// Determines equality between two `SourceCellModel` instances.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the two models have the same `id`; otherwise, `false`.
    public static func == (
        lhs: SourceCellModel,
        rhs: SourceCellModel
    ) -> Bool {
        return lhs.id == rhs.id
    }

    /// Hashes the `SourceCellModel` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.document)
    }

}

// MARK: - Identifiable

extension SourceCellModel: Identifiable {

    /// A unique identifier for the source cell, derived from the document's ID.
    public var id: Int64 {
        self.document.id ?? -1
    }

}
