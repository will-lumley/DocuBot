//
//  ConfigureProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class ConfigureProjectViewModel: DocuBotViewModel, Identifiable, @unchecked Sendable {

    // MARK: - Types

    public enum HelpType {
        case seed
        case topK
        case topP
        case contextLength
        case temperature
        case batchSize
        case stopSequence
        case maxTokenCount
    }

    public enum LoadState {
        case idle
        case creating
        case created
    }

    public enum OpenWindow {
        case project(ProjectViewModel.OpenWindowPackage)
    }

    public struct FormatConfiguration: Identifiable {
        public let order: Int
        public let format: Format
        public let isEnabled: Bool

        public var id: Int {
            self.order
        }
    }

    public typealias Format = ProjectSettings.DocumentationFormat

    // MARK: - Properties

    public var id = UUID()

    @Published public var projectDirectory: URL?
    @Published public var directoryText: String
    @Published public var projectName = ""
    @Published public var selectedLanguage: ProjectSettings.Language

    @Published public var formatConfigurations: [FormatConfiguration]

    @Published public var seed: Int = 1234
    @Published public var topK: Int = 40
    @Published public var topP: Double = 0.9
    @Published public var contextLength: Int = 2048
    @Published public var temperature: Double = 0.2
    @Published public var batchSize: Int = 2048
    @Published public var stopSequence: String?
    @Published public var maxTokenCount: Int = 1024*1024

    @Published public var loadState = LoadState.idle
    @Published public var continueButtonEnabled = false

    /// The encrypted data that makes up the secure directory bookmark
    public var projectDirectoryBookmarkData: Data?

    /// All the languages available for the user to choose from
    public let availableLanguages = ProjectSettings.Language.allCases

    /// This will be called to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    /// This will be called when this ViewModel wants the UI layer to close the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// This is used to create or close an `Alert`
    @Published public var alertConfiguration: AlertConfiguration?

    @Published public var helpConfiguration: HelpConfiguration?

    // MARK: - Lifecycle

    override public init(
        serviceContainer: ServiceContainer
    ) {
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

        // If there's even one "true"/checked format, then
        // we'll enable the Continue Button
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

public extension ConfigureProjectViewModel {

    var windowTitle: String {
        L10n.CreateProject.windowTitle
    }

    var formTitle: String {
        L10n.CreateProject.formTitle
    }

    var projectNameTitle: String {
        L10n.CreateProject.GeneralSection.Name.title
    }

    // MARK: General Section

    var generalSectionTitle: String {
        L10n.CreateProject.GeneralSection.title
    }

    var generalSectionSubtitle: String {
        L10n.CreateProject.GeneralSection.subtitle
    }

    var projectDirectoryTitle: String {
        L10n.CreateProject.GeneralSection.Directory.title
    }

    var languageTitle: String {
        L10n.CreateProject.GeneralSection.Language.title
    }

    // MARK: Format Section

    var formatSectionTitle: String {
        L10n.CreateProject.FormatSection.title
    }

    var formatSectionSubtitle: String {
        L10n.CreateProject.FormatSection.subtitle
    }

    func set(
        formatConfiguration: FormatConfiguration,
        isEnabled: Bool
    ) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        let oldConfiguration = self.formatConfigurations[index]

        // We only want to flip the `isEnabled`
        let newConfiguration = FormatConfiguration(
            order: oldConfiguration.order,
            format: oldConfiguration.format,
            isEnabled: isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    func update(
        formatConfiguration: FormatConfiguration,
        otherStr: String
    ) {
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
        let newConfiguration = FormatConfiguration(
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

    func remove(formatConfiguration: FormatConfiguration) {
        // We only want to remove `other` formats
        guard formatConfiguration.format.isOther else {
            return
        }

        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        self.formatConfigurations.remove(at: index)
    }

    // MARK: Advanced Section

    var advancedSectionTitle: String {
        L10n.CreateProject.AdvancedSection.title
    }

    var advancedSectionSubitle: String {
        L10n.CreateProject.AdvancedSection.subtitle
    }

    var seedTitle: String {
        L10n.CreateProject.AdvancedSection.seed
    }

    var topKTitle: String {
        L10n.CreateProject.AdvancedSection.topK
    }

    var topPTitle: String {
        L10n.CreateProject.AdvancedSection.topP
    }

    var contextLengthTitle: String {
        L10n.CreateProject.AdvancedSection.contextLength
    }

    var temperatureTitle: String {
        L10n.CreateProject.AdvancedSection.temperature
    }

    var batchSizeTitle: String {
        L10n.CreateProject.AdvancedSection.batchSize
    }

    var stopSequenceTitle: String {
        L10n.CreateProject.AdvancedSection.stopSequence
    }

    var maxTokenCountTitle: String {
        L10n.CreateProject.AdvancedSection.maxTokenCount
    }

    var resetDefaultButtonTitle: String {
        L10n.CreateProject.AdvancedSection.resetDefaults
    }

    // MARK: Other

    var createProjectButtonTitle: String {
        L10n.CreateProject.createButton
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
                    seed: self.seed,
                    topK: self.topK,
                    topP: self.topP,
                    contextLength: self.contextLength,
                    temperature: self.temperature,
                    batchSize: self.batchSize,
                    stopSequence: self.stopSequence,
                    maxTokenCount: self.maxTokenCount,
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
                self.alertConfiguration = .init(
                    title: L10n.CreateProject.Error.FailedToCreate.title,
                    message: error.localizedDescription
                )
            }
        }
    }

    func helpButtonSelected(with type: HelpType) {
        self.helpConfiguration = .init(type: type) {
            self.helpConfiguration = nil
        }
    }

    func resetDefaultValuesButtonSelected() {
        self.seed = 1234
        self.topK = 40
        self.topP = 0.9
        self.contextLength = 2048
        self.temperature = 0.2
        self.batchSize = 2048
        self.stopSequence = ""
        self.maxTokenCount = 1024*1024
    }

}

// MARK: - Preview

public extension ConfigureProjectViewModel {

    static var mock: ConfigureProjectViewModel {
        .init(
            serviceContainer: .mock
        )
    }

}
