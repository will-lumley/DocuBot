//
//  SourcesViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 23/10/2024.
//

import DocuBotModel
import DocuBotService
import Foundation

/// A delegate protocol for handling source cell interactions in the `SourcesViewModel`.
public protocol SourceCellModelDelegate: AnyObject {

    /// Determines whether the score should be displayed for a source cell.
    ///
    /// - Returns: `true` if the score should be displayed; otherwise, `false`.
    func shouldShowScore() -> Bool
}

/// A ViewModel for managing and displaying a list of source documents within the DocuBot application.
public class SourcesViewModel: DocuBotViewModel {

    // MARK: - Properties

    /// The collection of source cell models managed by this ViewModel.
    public let sources: [SourceCellModel]

    // MARK: - Lifecycle

    /// Initializes a new `SourcesViewModel`.
    ///
    /// - Parameters:
    ///   - sources: The array of `SourceCellModel` instances representing source documents.
    ///   - serviceContainer: The `ServiceContainer` providing shared services for the ViewModel.
    public init(sources: [SourceCellModel], serviceContainer: ServiceContainer) {
        self.sources = sources
        super.init(serviceContainer: serviceContainer)
    }
}

// MARK: - Identifiable

extension SourcesViewModel: Identifiable {

    /// A unique identifier for the `SourcesViewModel`, derived from the IDs of its source cells.
    public var id: Int64 {
        self.sources
            .map(\.id)
            .reduce(0, +)
    }

}
