//
//  ProjectSettings.Language+ViewModel.swift
//
//
//  Created by William Lumley on 20/8/2024.
//

import DocuBotModel
import Foundation

public extension ProjectSettings.Language {

    var name: String {
        switch self {
        case .english:
            return L10n.CreateProject.GeneralSection.Language.english
        case .espanol:
            return L10n.CreateProject.GeneralSection.Language.espanol
        }
    }

}
