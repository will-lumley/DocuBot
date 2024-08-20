//
//  ProjectSettings.DocumentationFormat+ViewModel.swift
//
//
//  Created by William Lumley on 18/8/2024.
//

import DocuBotModel
import Foundation

public extension ProjectSettings.DocumentationFormat {

    var name: String {
        switch self {
        case .html:
            return L10n.CreateProject.Configuration.Format.html
        case .md:
            return L10n.CreateProject.Configuration.Format.md
        case .rtf:
            return L10n.CreateProject.Configuration.Format.rtf
        case .txt:
            return L10n.CreateProject.Configuration.Format.txt
        case .other:
            return L10n.CreateProject.Configuration.Format.other
        }
    }

    var isOther: Bool {
        switch self {
        case .other:
            return true
        default:
            return false
        }
    }

    var otherStr: String? {
        switch self {
        case .other(let value):
            return value
        default:
            return nil
        }
    }

}
