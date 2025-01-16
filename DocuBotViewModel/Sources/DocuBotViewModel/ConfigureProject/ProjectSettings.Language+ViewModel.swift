//
//  ProjectSettings.Language+ViewModel.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import DocuBotModel
import Foundation

public extension ProjectSettings.Language {

    /// The localized name of the language.
    ///
    /// - Returns: A string representing the language name, localized for the current locale.
    var name: String {
        switch self {
        case .english:
            return L10n.ConfigureProject.GeneralSection.Language.english
        }
    }

}
