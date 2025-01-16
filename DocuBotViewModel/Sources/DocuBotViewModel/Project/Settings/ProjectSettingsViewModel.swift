//
//  ProjectSettingsViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class ProjectSettingsViewModel: DocuBotViewModel {

    // MARK: - Types

    public enum LoadState {
        case idle
        case creating
        case created
    }

    public struct OpenWindowPackage: Hashable, Codable {
        public let project: Project
        public let projectSettings: ProjectSettings
    }

    public typealias Format = ProjectSettings.DocumentationFormat

    public struct DocumentationFormatConfiguration: Identifiable {
        public let order: Int
        public let format: Format
        public let isEnabled: Bool

        public var id: Int {
            self.order
        }
    }

    // MARK: - Properties

    private let project: Project
    private let projectSettings: ProjectSettings

    @Published public var loadState = LoadState.idle
    @Published public var continueButtonEnabled = false
    @Published public var directoryText: String
    public let availableLanguages = ProjectSettings.Language.allCases

    public var projectDirectoryBookmarkData: Data?
    @Published public var projectDirectory: URL?
    @Published public var projectName = ""
    @Published public var formatConfigurations = [DocumentationFormatConfiguration]()
    @Published public var selectedLanguage: ProjectSettings.Language

    /// This will be called when this ViewModel wants the UI layer to close/dismiss the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    public init(project: Project, projectSettings: ProjectSettings, serviceContainer: ServiceContainer) {
        self.project = project
        self.projectSettings = projectSettings

        self.projectDirectory = URL(filePath: self.project.path)
        self.directoryText = self.project.path
        self.selectedLanguage = self.projectSettings.language

        var formatConfigurations = Format.allCases
            .enumerated()
            .map { index, format in
                DocumentationFormatConfiguration(
                    order: index,
                    format: format,
                    isEnabled: projectSettings.isEnabled(format)
                )
            }

        for (index, format) in projectSettings.otherFormats.enumerated() {
            let configuration = DocumentationFormatConfiguration(
                order: index + formatConfigurations.count,
                format: format,
                isEnabled: true
            )
            formatConfigurations.append(configuration)
        }
        self.formatConfigurations = formatConfigurations

        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // If there's even one "true"/checked format, then we'll enable the Continue Button
        let formatValidation = self.$formatConfigurations
            .map { $0.map { $0.isEnabled } } // Map it into an array of `Bool`s
            .map { $0.contains(true) }       // Check if there's even one `true`

        // The directory cannot be nil
        let directoryValidation = self.$projectDirectory
            .map { $0 != nil }

        // Combine the validation publishers
        Publishers.CombineLatest(formatValidation, directoryValidation)
            .map { $0 && $1 } // All validations must be met
            .assign(to: &$continueButtonEnabled)

        // When the directory is updated
        self.$projectDirectory
            .map { directory in
                // If the directory exists, return the path
                if let directory {
                    return directory.path()
                }

                // Return the placeholder text if there's no directory
                else {
                    return L10n.CreateProject.Configuration.Directory.select
                }
            }
            .assign(to: &$directoryText)

        // When the directory is updated, update the name
        self.$projectDirectory
            .compactMap { $0 }
            .map { $0.lastPathComponent }
            .assign(to: &$projectName)
    }

}

// MARK: - Public

public extension ProjectSettingsViewModel {

    var windowTitle: String {
        L10n.ProjectSettings.windowTitle
    }

    var title: String {
        self.project.name
    }

    var projectNameTitle: String {
        L10n.CreateProject.Configuration.Name.title
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

    var formatSectionTitle: String {
        L10n.CreateProject.Configuration.FormatSection.title
    }

    var saveButtonTitle: String {
        L10n.ProjectSettings.saveButton
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

    func saveButtonSelected() {
        /*
        Task {
            guard let projectID = self.project.id else {
                return
            }
            guard let projectDirectory = self.projectDirectory else {
                return
            }

            let supportedFormats = self.formatConfigurations
                .filter { $0.isEnabled }
                .map(\.format)

            let project = Project(
                id: self.project.id,
                path: projectDirectory.path(),
                name: self.projectName,
                isDirty: false,
                urlBookmarkData: self.projectDirectoryBookmarkData,
                urlBookmarkDataIsStale: false,
                createdAt: self.project.createdAt,
                updatedAt: .now
            )

            let settings = ProjectSettings(
                id: self.projectSettings.id,
                projectID: projectID,
                supportedFormats: supportedFormats,
                respondWithDocumentsOnly: false,
                language: self.selectedLanguage,
                createdAt: self.projectSettings.createdAt,
                updatedAt: .now
            )

            do {
                // Update the DB
                try await persistenceService.update(projectSettings: settings)
                try await persistenceService.update(project: project)

                // Close this window
                DispatchQueue.main.async {
                    self.onDismiss.send(())
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
         */
    }

}

// MARK: - Private

private extension ProjectSettingsViewModel {
    
}

// MARK: - Preview

public extension ProjectSettingsViewModel {

    static var mock: ProjectSettingsViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 1",
                isDirty: false,
                urlBookmarkData: nil,
                urlBookmarkDataIsStale: true,
                createdAt: .now,
                updatedAt: .now
            ),
            projectSettings: .init(
                projectID: 1,
                supportedFormats: [.rtf, .html],
                respondWithDocumentsOnly: true,
                language: .english,
                createdAt: .now,
                updatedAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
