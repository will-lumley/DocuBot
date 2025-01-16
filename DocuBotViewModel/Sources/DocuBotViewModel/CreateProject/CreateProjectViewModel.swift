//
//  CreateProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import DocuBotModel
import DocuBotService
import Foundation

public class CreateProjectViewModel: DocuBotViewModel {

    // MARK: - Types

    public typealias Format = ProjectSettings.DocumentationFormat

    public struct OpenWindowPackage: Hashable, Codable {
        public let directory: URL
    }

    public struct DocumentationFormatConfiguration: Identifiable {
        public let order: Int
        public let format: Format
        public let isEnabled: Bool

        public var id: Int {
            self.order
        }
    }

    // MARK: - Properties

    @Published public var formatConfigurations: [DocumentationFormatConfiguration]
    @Published public var continueButtonEnabled = false

    @Published public var selectedLanguage: ProjectSettings.Language
    public let availableLanguages = ProjectSettings.Language.allCases

    public let directory: URL

    // MARK: - Lifecycle

    public init(directory: URL, serviceContainer: ServiceContainer) {
        self.directory = directory
        self.selectedLanguage = .english

        self.formatConfigurations = Format.allCases
            .enumerated()
            .map { index, format in
                .init(order: index, format: format, isEnabled: format.isOther == false)
            }

        super.init(serviceContainer: serviceContainer)

        self.formatConfigurations.append(
            .init(order: 9, format: .other("hello"), isEnabled: true)
        )
    }

    public override func configureBindings() {
        super.configureBindings()

        // If there's even one "true"/checked, then we'll enable the Continue Button
        self.$formatConfigurations
            .map { $0.map { $0.isEnabled } } // Map it into an array of `Bool`s
            .map { $0.contains(true) }       // Check if there's even one `true`
            .assign(to: &$continueButtonEnabled)
    }

}

// MARK: - Public

public extension CreateProjectViewModel {

    var windowTitle: String {
        L10n.CreateProject.windowTitle
    }

    var formTitle: String {
        L10n.CreateProject.formTitle
    }

    var generalSectionTitle: String {
        L10n.CreateProject.Configuration.GeneralSection.title
    }

    var projectDirectoryTitle: String {
        L10n.CreateProject.Configuration.ProjectDirectory.title
    }

    var languageTitle: String {
        L10n.CreateProject.Configuration.Language.title
    }

    var projectDirectory: String {
        self.directory.path()
    }

    var formatSectionTitle: String {
        L10n.CreateProject.Configuration.FormatSection.title
    }

    func set(formatConfiguration: DocumentationFormatConfiguration, isEnabled: Bool) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        let oldConfiguration = self.formatConfigurations[index]

        // We only want to flip the `isEnabled`
        let newConfiguration = DocumentationFormatConfiguration(
            order: oldConfiguration.order,
            format: oldConfiguration.format,
            isEnabled: isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    func update(formatConfiguration: DocumentationFormatConfiguration, otherStr: String) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        var formattedOtherStr = otherStr

        // Is the first character NOT a full-stop? If not, add one in
        if formattedOtherStr.first != "." {
            formattedOtherStr = ".\(formattedOtherStr)"
        }

        let oldConfiguration = self.formatConfigurations[index]

        let format = Format.other(formattedOtherStr)

        // We only want to update the `format`
        let newConfiguration = DocumentationFormatConfiguration(
            order: oldConfiguration.order,
            format: format,
            isEnabled: oldConfiguration.isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    func createNewFormat() {
        self.formatConfigurations.append(
            .init(
                order: self.formatConfigurations.count + 1,
                format: .other("."),
                isEnabled: true
            )
        )
    }

    func remove(formatConfiguration: DocumentationFormatConfiguration) {
        // We only want to remove `other` formats
        guard formatConfiguration.format.isOther else {
            return
        }

        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        self.formatConfigurations.remove(at: index)
    }

}

// MARK: - Private

private extension CreateProjectViewModel {

    

}

// MARK: - Preview

public extension CreateProjectViewModel {

    static var mock: CreateProjectViewModel {
        .init(
            directory: URL(string: "/Users/will/Desktop/")!,
            serviceContainer: .mock
        )
    }

}
