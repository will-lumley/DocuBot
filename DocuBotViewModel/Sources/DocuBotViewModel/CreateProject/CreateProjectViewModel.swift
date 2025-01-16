//
//  CreateProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class CreateProjectViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    actor ProjectState {
        var projectDirectory: URL?
        var projectName: String = ""
        var formatConfigurations: [CreateProjectViewModel.DocumentationFormatConfiguration] = []
    }

    public enum OpenWindow {
        case project(ProjectViewModel.OpenWindowPackage)
    }

    public struct OpenWindowPackage: Hashable, Codable {

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

    public enum LoadState {
        case idle
        case creating
        case created
    }

    // MARK: - Properties

    @Published public var loadState = LoadState.idle
    @Published public var continueButtonEnabled = false
    @Published public var directoryText: String
    public let availableLanguages = ProjectSettings.Language.allCases

    public var projectDirectoryBookmarkData: Data?
    @Published public var projectDirectory: URL?
    @Published public var projectName = ""
    @Published public var formatConfigurations: [DocumentationFormatConfiguration]
    @Published public var selectedLanguage: ProjectSettings.Language

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// This will be called when this ViewModel wants the UI layer to close/dismiss the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    override public init(serviceContainer: ServiceContainer) {
        self.directoryText = L10n.CreateProject.Configuration.Directory.select
        self.selectedLanguage = .english

        self.formatConfigurations = Format.allCases
            .enumerated()
            .map { index, format in
                .init(order: index, format: format, isEnabled: format.isOther == false)
            }

        super.init(serviceContainer: serviceContainer)
    }

    override public func configureBindings() {
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

public extension CreateProjectViewModel {

    var windowTitle: String {
        L10n.CreateProject.windowTitle
    }

    var formTitle: String {
        L10n.CreateProject.formTitle
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

    var createProjectButtonTitle: String {
        L10n.CreateProject.createButton
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

    func createProjectButtonSelected() {
        guard let directory = self.projectDirectory else {
            return
        }

        let project = Project(
            path: directory.path(),
            name: self.projectName,
            isDirty: false,
            urlBookmarkData: self.projectDirectoryBookmarkData,
            urlBookmarkDataIsStale: false,
            createdAt: .now,
            updatedAt: .now
        )

        Task {
            do {
                // Insert the Project into the DB
                let inserted = try await persistenceService.insert(project: project)

                guard let id = inserted.id else {
                    return
                }

                let supportedFormats = self.formatConfigurations
                    .filter { $0.isEnabled }
                    .map(\.format)

                // Insert the ProjectSettings into the DB
                let settings = ProjectSettings(
                    projectID: id,
                    supportedFormats: supportedFormats,
                    respondWithDocumentsOnly: false,
                    language: self.selectedLanguage,
                    createdAt: .now,
                    updatedAt: .now
                )
                _ = try await persistenceService.insert(settings: settings)

                await MainActor.run {
                    // Close this current window
                    self.onDismiss.send(())

                    // Open the Window with the project that we just inserted
                    self.onOpen.send(
                        .project(
                            .init(project: inserted)
                        )
                    )
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

}

// MARK: - Preview

public extension CreateProjectViewModel {

    static var mock: CreateProjectViewModel {
        .init(
            serviceContainer: .mock
        )
    }

}
