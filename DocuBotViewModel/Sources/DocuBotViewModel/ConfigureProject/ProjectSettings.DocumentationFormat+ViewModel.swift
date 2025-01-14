//
//  ProjectSettings.DocumentationFormat+ViewModel.swift
//
//
//  Created by William Lumley on 18/8/2024.
//

import DocuBotModel
import Foundation

public extension ProjectSettings.DocumentationFormat {

    /// The localized name of the documentation format.
    ///
    /// - Returns: A string representing the name of the documentation format, localized for the current locale.
    var name: String {
        switch self {
        case .html:
            return L10n.ConfigureProject.FormatSection.Format.html
        case .md:
            return L10n.ConfigureProject.FormatSection.Format.md
        case .rtf:
            return L10n.ConfigureProject.FormatSection.Format.rtf
        case .txt:
            return L10n.ConfigureProject.FormatSection.Format.txt
        case .pdf:
            return L10n.ConfigureProject.FormatSection.Format.pdf
        case .word:
            return L10n.ConfigureProject.FormatSection.Format.word
        case .other:
            return L10n.ConfigureProject.FormatSection.Format.other
        }
    }

    /// The custom string value associated with the `.other` format.
    ///
    /// - Returns: A string representing the custom format if `.other` is selected, or `nil` for other cases.
    var otherStr: String? {
        switch self {
        case .other(let value):
            return value
        default:
            return nil
        }
    }

}
