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

    private let model: Model

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
        "\(self.model.size) bytes"
    }

}

// MARK: - Identifiable

extension ModelCellModel: Identifiable {

    public var id: Int64 {
        self.model.id ?? -1
    }

}
