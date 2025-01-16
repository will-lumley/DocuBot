//
//  ConfigureProjetViewModel+FormValidationError.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel.FormValidationError {

    internal typealias Strings = L10n.Error.ConfigureProject.FormValidation

    /// A localized description of the form validation error.
    ///
    /// - Returns: A string describing the specific form validation error, localized for the current locale.
    var errorDescription: String? {
        switch self {
        case .missingModel:
            return Strings.missingModel
        case .missingName:
            return Strings.missingName
        case .missingFormat:
            return Strings.missingFormat
        case .missingSeed:
            return Strings.missingSeed
        case .missingTopK:
            return Strings.missingTopK
        case .invalidTopP:
            return Strings.invalidTopP
        case .missingContextLength:
            return Strings.missingContextLength
        case .missingBatchSize:
            return Strings.missingBatchSize
        case .missingMaxTokenCount:
            return Strings.missingMaxTokenCount
        case .missingSystemPrompt:
            return Strings.missingSystemPrompt
        case .missingDirectory:
            return Strings.missingDirectory
        case .missingDirectoryData:
            return Strings.missingDirectoryData
        }
    }

}
