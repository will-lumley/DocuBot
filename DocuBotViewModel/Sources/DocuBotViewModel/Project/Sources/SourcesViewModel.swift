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

    public init(sources: [SourceCellModel], serviceContainer: ServiceContainer) {
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
