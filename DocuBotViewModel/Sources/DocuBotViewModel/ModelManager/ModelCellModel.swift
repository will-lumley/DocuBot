//
//  ModelCellViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 30/10/2024.
//

import DocuBotModel
import Foundation

/// A ViewModel representing an LLM model.
@Observable
public final class ModelCellModel: Sendable, Equatable {

    // MARK: - Properties

    /// The underlying `LLMModel` associated with this cell.
    let model: LLMModel

    // MARK: - Lifecycle

    /// Initializes a new `ModelCellModel`.
    ///
    /// - Parameter model: The language model to be represented by this ViewModel.
    public init(model: LLMModel) {
        self.model = model
    }
}

// MARK: - Public

public extension ModelCellModel {

    /// The name of the model, displayed as the cell's title.
    var title: String {
        self.model.name
    }

    /// The formatted size of the model, displayed as the cell's subtitle.
    ///
    /// - Discussion:
    /// The size is formatted into gigabytes (GB) for better readability.
    var subtitle: String {
        let size = Double(self.model.size)
        let sizeFormat = ModelManagerViewModel.formatBytesToGB(size)
        return L10n.ModelManager.Cell.subtitle(sizeFormat)
    }
}

// MARK: - Hashable

extension ModelCellModel: Hashable {

    /// Compares two `ModelCellModel` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand instance.
    ///   - rhs: The right-hand instance.
    /// - Returns: `true` if the underlying models are equal; otherwise, `false`.
    public static func == (lhs: ModelCellModel, rhs: ModelCellModel) -> Bool {
        return lhs.model == rhs.model
    }

    /// Hashes the `ModelCellModel` into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use for hashing.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
}

// MARK: - Identifiable

extension ModelCellModel: Identifiable {

    /// A unique identifier for the cell, derived from the model's ID.
    ///
    /// - Returns: The model's ID, or `-1` if the ID is unavailable.
    public var id: Int64 {
        self.model.id ?? -1
    }
}
