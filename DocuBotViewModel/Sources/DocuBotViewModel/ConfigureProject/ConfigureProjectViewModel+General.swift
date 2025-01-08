//
//  ConfigureProjectViewModel+General.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    /// The title for the general section in the configuration UI.
    ///
    /// - Returns: A localized string representing the title of the general section.
    var generalSectionTitle: String {
        L10n.ConfigureProject.GeneralSection.title
    }

    /// The subtitle for the general section in the configuration UI.
    ///
    /// - Returns: A localized string providing additional context for the general section.
    var generalSectionSubtitle: String {
        L10n.ConfigureProject.GeneralSection.subtitle
    }

    /// The title for the project name configuration option.
    ///
    /// - Returns: A localized string representing the title of the project name field.
    var projectNameTitle: String {
        L10n.ConfigureProject.GeneralSection.Name.title
    }

    /// The title for the project directory configuration option.
    ///
    /// - Returns: A localized string representing the title of the project directory field.
    var projectDirectoryTitle: String {
        L10n.ConfigureProject.GeneralSection.Directory.title
    }

    /// The title for the project language configuration option.
    ///
    /// - Returns: A localized string representing the title of the language selection field.
    var languageTitle: String {
        L10n.ConfigureProject.GeneralSection.Language.title
    }

    /// The title for the project model configuration option.
    ///
    /// - Returns: A localized string representing the title of the model selection field.
    var modelTitle: String {
        L10n.ConfigureProject.GeneralSection.Model.title
    }

}
