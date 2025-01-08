//
//  Project.AlertStatus+ViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotModel
import SFSafeSymbols

// MARK: - AlertStatus

public extension Project.AlertStatus {

    /// A human-readable title describing the alert status of a project.
    ///
    /// - Returns: A localized string representing the alert status title, or `nil` if no status is present.
    var title: String? {
        switch self {
        case .warning(let warning):
            switch warning {
            case .directoryChanged:
                return L10n.Project.Warning.directoryChanged
            case .isDirty:
                return L10n.Project.Warning.isDirty
            case .metricChanged:
                return L10n.Project.Warning.metricChanged
            case .modelChanged:
                return L10n.Project.Warning.modelChanged
            case .formatsChanged:
                return L10n.Project.Warning.formatsChanged
            }
        case .error(let error):
            switch error {
            case .firstSync:
                return L10n.Project.Error.firstSync
            }
        case .none:
            return nil
        }
    }

}
