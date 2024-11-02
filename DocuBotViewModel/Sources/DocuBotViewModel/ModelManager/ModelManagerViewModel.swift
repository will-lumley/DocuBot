//
//  ModelManagerViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 29/10/2024.
//

import Combine
import Foundation

public class ModelManagerViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    @Published public var models = [ModelCellModel]()

    // MARK: - Properties

    // MARK: - Lifecycle

    override public func configureBindings() {
        super.configureBindings()

        persistenceService.getModels()
            .map { $0.map(ModelCellModel.init) }
            .replaceError(with: [])
            .assign(to: &$models)
    }

}

// MARK: - Public

public extension ModelManagerViewModel {

    var windowTitle: String {
        L10n.ModelManager.windowTitle
    }

}
