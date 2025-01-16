//
//  ModelCellViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 30/10/2024.
//

import DocuBotModel
import Foundation

@Observable
public class ModelCellModel {

    // MARK: - Properties

    let model: Model

    // MARK: - Lifecycle

    init(model: Model) {
        self.model = model
    }

}

// MARK: - Public

public extension ModelCellModel {

    var title: String {
        self.model.name
    }

    var subtitle: String {
        let size = Double(self.model.size)
        let sizeFormat = ModelManagerViewModel.formatBytesToGB(size)
        return L10n.ModelManager.Cell.subtitle(sizeFormat)
    }

}

// MARK: - Hashable

extension ModelCellModel: Hashable {

    public static func == (lhs: ModelCellModel, rhs: ModelCellModel) -> Bool {
        return lhs.model == rhs.model
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }

}

// MARK: - Identifiable

extension ModelCellModel: Identifiable {

    public var id: Int64 {
        self.model.id ?? -1
    }

}
