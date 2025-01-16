//
//  ConfigureProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation

/// A `ViewModel` responsible for managing the configuration of a DocuBot project.
///
/// This ViewModel handles project settings, including directory, name, language,
/// format configurations, and advanced LLM options. It supports both creating new
/// projects and editing existing ones.
public class ConfigureProjectViewModel: DocuBotViewModel, Identifiable, @unchecked Sendable {

    // MARK: - Types

    /// Represents the various types of help information available in the configuration UI.
    public enum HelpType: CaseIterable, Sendable {
        case embeddingModel
        case similarityMetric
        case seed
        case topK
        case topP
        case contextLength
        case temperature
        case batchSize
        case stopSequence
        case maxTokenCount
        case systemPrompt
        case strictMode
    }

    /// Errors related to form validation during project configuration.
    public enum FormValidationError: LocalizedError {
        case missingDirectory
        case missingDirectoryData
        case missingName
        case missingModel
        case missingFormat
        case missingSeed
        case missingTopK
        case invalidTopP
        case missingContextLength
        case missingBatchSize
        case missingMaxTokenCount
        case missingSystemPrompt
    }

    /// Represents the type of window to be opened.
    public enum OpenWindow: Hashable {
        case project(ProjectViewModel.OpenWindowPackage)
    }

    /// Specifies whether the project is being created or edited.
    public enum ConfigureType {
        case creating
        case editing
    }

    /// Represents a configuration for document formats.
    public struct FormatConfiguration: Identifiable, Hashable {
        /// The order in which this format appears.
        public let order: Int
        /// The specific format being configured.
        public let format: Format
        /// Indicates whether this format is enabled.
        public let isEnabled: Bool

        /// The unique identifier for this format configuration.
        public var id: Int {
            self.order
        }
    }

    /// Holds information about the project, settings, and selected model.
    public struct ProjectInfo {
        public let project: Project
        public let settings: ProjectSettings
        public let model: LLMModel
    }

    public typealias Format = ProjectSettings.DocumentationFormat
    public typealias OnSave = () -> Void

    // MARK: - Properties

    /// The unique identifier for this ViewModel.
    public var id = UUID()

    /// Information about the project, if it is being edited.
    public let projectInfo: ProjectInfo?

    /// The directory for the project.
    @Published public var projectDirectory: URL?

    /// The text representation of the project directory.
    @Published public var projectDirectoryText = ""

    /// The name of the project.
    @Published public var projectName = ""

    /// The selected language for the project.
    @Published public var selectedLanguage: ProjectSettings.Language

    /// The selected LLM model for the project.
    @Published public var selectedModel: LLMModel

    /// The list of document format configurations.
    @Published public var formatConfigurations: [FormatConfiguration]

    /// The system prompt for the LLM.
    @Published public var systemPrompt: String

    /// The embedding model for the project.
    @Published public var embeddingModel: ProjectSettings.EmbeddingModel

    /// The similarity metric for document matching.
    @Published public var similarityMetric: ProjectSettings.SimilarityMetric

    /// Advanced configuration options for LLMs.
    @Published public var seed: Int
    @Published public var topK: Int
    @Published public var topP: Double
    @Published public var contextLength: Int
    @Published public var temperature: Double
    @Published public var batchSize: Int
    @Published public var stopSequence: String?
    @Published public var maxTokenCount: Int
    @Published public var strictMode: Bool

    /// A closure to be called when the settings are saved.
    var onSave: OnSave?

    /// The encrypted data representing the secure directory bookmark.
    public var projectDirectoryBookmarkData: Data?

    /// The list of all available LLM models.
    public var availableModels = [LLMModel]()

    /// The list of all available languages.
    public let availableLanguages = ProjectSettings.Language.allCases

    /// The list of all available embedding models.
    public let availableEmbeddingModels = ProjectSettings.EmbeddingModel.allCases

    /// The list of all available similarity metrics.
    public let availableSimilarityMetrics = ProjectSettings.SimilarityMetric.allCases

    /// Used to trigger the opening of a new window.
    @Published public var onOpen = CurrentValueSubject<OpenWindow?, Never>(nil)

    /// Used to signal the dismissal of the current window.
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// Used to manage and display alert configurations.
    @Published public var alertConfiguration: AsyncAlertConfiguration?

    /// Used to display help information to the user.
    @Published public var helpConfiguration: HelpConfiguration?

    // MARK: - Initializer

    /// Initializes a new instance of `ConfigureProjectViewModel`.
    ///
    /// - Parameters:
    ///   - projectInfo: Optional project information for editing an existing project.
    ///   - availableModels: A list of available LLM models for selection.
    ///   - serviceContainer: The container providing necessary services.
    ///   - onSave: A closure to be called when the settings are saved.
    public init(
        projectInfo: ProjectInfo? = nil,
        availableModels: [LLMModel],
        serviceContainer: ServiceContainer,
        onSave: OnSave? = nil
    ) {
        self.onSave = onSave
        self.availableModels = availableModels

        // If we're modifying an existing project/settings
        if let projectInfo {
            self.projectInfo = projectInfo

            self.selectedModel = projectInfo.model

            self.projectDirectory = URL(fileURLWithPath: projectInfo.project.path)
            self.projectDirectoryBookmarkData = projectInfo.project.urlBookmarkData
            self.projectName = projectInfo.project.name
            self.selectedLanguage = projectInfo.settings.language

            var formatConfigurations = Format.allCases
                .enumerated()
                .map { index, format in
                    FormatConfiguration(
                        order: index,
                        format: format,
                        isEnabled: projectInfo.settings.isEnabled(format)
                    )
                }

            for (index, format) in projectInfo.settings.otherFormats.enumerated() {
                let configuration = FormatConfiguration(
                    order: index + formatConfigurations.count,
                    format: format,
                    isEnabled: true
                )
                formatConfigurations.append(configuration)
            }
            self.formatConfigurations = formatConfigurations

            self.systemPrompt = projectInfo.settings.systemPrompt
            self.embeddingModel = projectInfo.settings.embeddingModel
            self.similarityMetric = projectInfo.settings.similarityMetric
            self.seed = projectInfo.settings.seed
            self.topK = projectInfo.settings.topK
            self.topP = projectInfo.settings.topP
            self.contextLength = projectInfo.settings.contextLength
            self.temperature = projectInfo.settings.temperature
            self.batchSize = projectInfo.settings.batchSize
            self.stopSequence = projectInfo.settings.stopSequence
            self.maxTokenCount = projectInfo.settings.maxTokenCount
            self.strictMode = projectInfo.settings.strictMode
        }

        // This is a brand new project/settings
        else {
            self.projectInfo = nil

            guard let firstModel = availableModels.first else {
                fatalError()
            }
            self.selectedModel = firstModel

            self.selectedLanguage = .english
            self.projectDirectoryText = L10n.ConfigureProject.GeneralSection.Directory.select

            self.formatConfigurations = Format.allCases
                .enumerated()
                .map { index, format in
                    .init(order: index, format: format, isEnabled: format.isOther == false)
                }

            self.systemPrompt = L10n.ConfigureProject.AdvancedSection.SystemPrompt.default
            self.embeddingModel = .distilbert
            self.similarityMetric = .cosine
            self.seed = 1234
            self.topK = 40
            self.topP = 0.9
            self.contextLength = 2048
            self.temperature = 0.2
            self.batchSize = 2048
            self.stopSequence = ""
            self.maxTokenCount = 1024*1024
            self.strictMode = false

            self.systemPrompt = L10n.ConfigureProject.AdvancedSection.SystemPrompt.default
            self.embeddingModel = .distilbert
            self.similarityMetric = .cosine
        }

        super.init(serviceContainer: serviceContainer)
    }

    /// Configures data bindings for the ViewModel.
    override public func configureBindings() {
        super.configureBindings()

        // Bind the project directory updates to the directory text.
        self.$projectDirectory
            .compactMap { $0?.path() }
            .assign(to: &$projectDirectoryText)
    }

}

// MARK: - Public

public extension ConfigureProjectViewModel {

    /// The title of the configuration form.
    ///
    /// - Returns: A localized string based on whether the user is creating or editing a project.
    var formTitle: String {
        switch self.configureType {
        case .creating:
            return L10n.ConfigureProject.Creating.formTitle
        case .editing:
            return L10n.ConfigureProject.Editing.formTitle
        }
    }

    /// The title for the "Reset Defaults" button in the advanced settings.
    ///
    /// - Returns: A localized string indicating the button's purpose.
    var resetDefaultButtonTitle: String {
        L10n.ConfigureProject.AdvancedSection.resetDefaults
    }

    /// Updates the ViewModel with the selected directory.
    ///
    /// - Parameter directory: The selected directory URL.
    ///
    /// - Discussion:
    /// This method validates the provided directory, creates a security-scoped bookmark, and updates
    /// the `projectDirectory`, `projectDirectoryBookmarkData`, and `projectName` properties.
    ///
    /// If an error occurs, an alert is configured with details about the failure.
    func directorySelected(_ directory: URL?) {
        do {
            guard let directory else {
                throw FormValidationError.missingDirectory
            }

            let bookmarkData = try directory.bookmarkData(
                options: .securityScopeAllowOnlyReadAccess,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )

            self.projectDirectory = directory
            self.projectDirectoryBookmarkData = bookmarkData
            self.projectName = directory.lastPathComponent
        } catch {
            logService.log(
                with: .error,
                "Failed to get directory: \(error)"
            )
            self.alertConfiguration = .init(
                title: L10n.Error.Project.UpdateBookmark.title,
                message: error.description
            )
        }
    }

    /// The title for the save button in the configuration form.
    ///
    /// - Returns: A localized string based on whether the user is creating or editing a project.
    var saveButtonTitle: String {
        switch self.configureType {
        case .creating:
            return L10n.ConfigureProject.Creating.createButton
        case .editing:
            return L10n.ConfigureProject.Editing.createButton
        }
    }

    /// Handles the save button selection.
    ///
    /// - Discussion:
    /// Triggers the `save()` method asynchronously to persist the project settings.
    func saveButtonSelected() async {
        await self.save()
    }

    /// Displays help information for a specific type of configuration setting.
    ///
    /// - Parameter type: The `HelpType` representing the help topic.
    ///
    /// - Discussion:
    /// Configures a `HelpConfiguration` to display help content. Once dismissed, the configuration
    /// is cleared.
    func helpButtonSelected(with type: HelpType) {
        self.helpConfiguration = .init(type: type) {
            self.helpConfiguration = nil
        }
    }

}

// MARK: - Private

private extension ConfigureProjectViewModel {

    /// Provides a message explaining why a full resync is required, if applicable.
    ///
    /// - Returns: A localized string describing the reason for resync or `nil` if no resync is needed.
    var resyncMessage: String? {
        if self.metricChanged {
            return L10n.ConfigureProject.Resync.Metric.message
        } else if self.embeddingModelChanged {
            return L10n.ConfigureProject.Resync.Model.message
        } else if self.directoryChanged {
            return L10n.ConfigureProject.Resync.Directory.message
        } else if self.formatsChanged {
            return L10n.ConfigureProject.Resync.Format.message
        }

        return nil
    }

    /// Determines the appropriate alert status to be set after changes.
    ///
    /// - Returns: An updated `Project.AlertStatus` or `nil` if no changes require an alert.
    var newAlertStatus: Project.AlertStatus? {
        // If we've changed metrics
        if self.metricChanged {
            return .warning(warning: .metricChanged)
        }
        // If we've changed models
        else if self.embeddingModelChanged {
            return .warning(warning: .modelChanged)
        }
        // If we've changed formats
        else if self.formatsChanged {
            return .warning(warning: .formatsChanged)
        }
        // If we've changed directories
        else if self.directoryChanged {
            return .warning(warning: .directoryChanged)
        }

        return nil
    }

    /// Checks whether the similarity metric has been modified.
    var metricChanged: Bool {
        self.projectInfo?.settings.similarityMetric != self.similarityMetric
    }

    /// Checks whether the embedding model has been modified.
    var embeddingModelChanged: Bool {
        self.projectInfo?.settings.embeddingModel != self.embeddingModel
    }

    /// Checks whether the supported documentation formats have been modified.
    var formatsChanged: Bool {
        self.projectInfo?.settings.supportedFormats != self.supportedFormats
    }

    /// Checks whether the project directory has been modified.
    var directoryChanged: Bool {
        guard var newPath = self.projectDirectory?.path() else {
            return false
        }
        guard var oldPath = self.projectInfo?.project.path else {
            return false
        }

        if newPath.hasSuffix("/") {
            newPath.removeLast()
        }
        if oldPath.hasSuffix("/") {
            oldPath.removeLast()
        }

        return newPath != oldPath
    }

    /// Determines whether any changes require a full resync of the project.
    var resyncNeeded: Bool {
        // We only consider this if we're modifying an existing project
        if self.configureType == .creating {
            return false
        }

        return self.metricChanged || self.embeddingModelChanged || self.directoryChanged || self.formatsChanged
    }

    /// Retrieves the list of enabled documentation formats.
    var supportedFormats: [ProjectSettings.DocumentationFormat] {
        self.formatConfigurations
            .filter { $0.isEnabled }
            .map(\.format)
    }

    /// Determines the type of configuration being performed (creation or editing).
    var configureType: ConfigureType {
        self.projectInfo != nil ? .editing : .creating
    }

    /// Finalizes the `Project` object based on the current configuration settings.
    ///
    /// - Throws: `FormValidationError` if any required fields are missing.
    /// - Returns: A fully constructed `Project` object.
    func finalisedProject() throws -> Project {
        guard let directory = self.projectDirectory else {
            throw FormValidationError.missingDirectory
        }
        guard let bookmarkData = self.projectDirectoryBookmarkData else {
            throw FormValidationError.missingDirectoryData
        }

        // We're modifying an existing project
        if let project = self.projectInfo?.project {
            var project = Project(
                id: project.id,
                path: directory.path(),
                name: self.projectName,
                urlBookmarkData: bookmarkData,
                documentationCheckSum: project.documentationChecksum,
                exampleQuestions: project.exampleQuestions,
                alertStatus: project.alertStatus,
                createdAt: project.createdAt,
                updatedAt: .now
            )

            if let newAlertStatus = self.newAlertStatus {
                project.set(alertStatus: newAlertStatus)
            }
            return project
        }
        // We're creating a brand new project
        else {
            return Project(
                path: directory.path(),
                name: self.projectName,
                urlBookmarkData: bookmarkData,
                documentationCheckSum: nil,
                exampleQuestions: [],
                alertStatus: .error(error: .firstSync),
                createdAt: .now,
                updatedAt: .now
            )
        }
    }

    /// Finalizes the `ProjectSettings` object based on the current configuration settings.
    ///
    /// - Parameter projectID: The unique identifier of the associated project.
    /// - Throws: `LLMModel.ModelError` if the selected model lacks an ID.
    /// - Returns: A fully constructed `ProjectSettings` object.
    func finalisedSettings(for projectID: Int64) throws -> ProjectSettings {
        // We're modifying an existing project
        if let projectInfo = self.projectInfo {
            let modelID = try self.selectedModel.id.orThrow(LLMModel.ModelError.missingID)

            return ProjectSettings(
                id: projectInfo.settings.id,
                projectID: projectInfo.settings.projectID,
                modelID: modelID,
                supportedFormats: self.supportedFormats,
                language: self.selectedLanguage,
                embeddingModel: self.embeddingModel,
                similarityMetric: self.similarityMetric,
                seed: self.seed,
                topK: self.topK,
                topP: self.topP,
                contextLength: self.contextLength,
                temperature: self.temperature,
                batchSize: self.batchSize,
                stopSequence: self.stopSequence,
                maxTokenCount: self.maxTokenCount,
                systemPrompt: self.systemPrompt,
                strictMode: self.strictMode,
                createdAt: projectInfo.settings.createdAt,
                updatedAt: .now
            )
        }
        // We're creating a brand new project
        else {
            let modelID = try self.selectedModel.id.orThrow(LLMModel.ModelError.missingID)

            return ProjectSettings(
                projectID: projectID,
                modelID: modelID,
                supportedFormats: supportedFormats,
                language: self.selectedLanguage,
                embeddingModel: self.embeddingModel,
                similarityMetric: self.similarityMetric,
                seed: self.seed,
                topK: self.topK,
                topP: self.topP,
                contextLength: self.contextLength,
                temperature: self.temperature,
                batchSize: self.batchSize,
                stopSequence: self.stopSequence,
                maxTokenCount: self.maxTokenCount,
                systemPrompt: self.systemPrompt,
                strictMode: self.strictMode,
                createdAt: .now,
                updatedAt: .now
            )
        }
    }

    /// Persists a `Project` to the database by either creating a new entry or updating an existing one.
    ///
    /// - Parameter project: The `Project` object to be persisted.
    /// - Returns: The persisted `Project` object, including any updated information such as
    /// database identifiers.
    /// - Throws: An error if the persistence operation fails.
    func persist(project: Project) async throws -> Project {
        switch self.configureType {
        case .creating:
            let project = try await persistenceService.insert(project: project)
            return project
        case .editing:
            let project = try await persistenceService.update(project: project)
            return project
        }
    }

    /// Persists `ProjectSettings` to the database by either creating a new entry or updating an existing one.
    ///
    /// - Parameter settings: The `ProjectSettings` object to be persisted.
    /// - Returns: The persisted `ProjectSettings` object, including any updated information
    /// such as database identifiers.
    /// - Throws: An error if the persistence operation fails.
    func persist(settings: ProjectSettings) async throws -> ProjectSettings {
        switch self.configureType {
        case .creating:
            let settings = try await persistenceService.insert(settings: settings)
            return settings
        case .editing:
            let settings = try await persistenceService.update(settings: settings)
            return settings
        }
    }

    /// Validates the current form configuration for required fields and constraints.
    ///
    /// - Throws: `FormValidationError` if validation fails.
    func checkFormValidation() throws(FormValidationError) {
        // swiftlint:disable:previous cyclomatic_complexity

        // Check our project directory
        if self.projectDirectory == nil {
            throw .missingDirectory
        }

        // Check our secure URL data
        if self.projectDirectoryBookmarkData == nil {
            throw .missingDirectoryData
        }

        // Check our project name
        if self.projectName.isEmpty {
            throw .missingName
        }

        // Check that we have at least one single valid format
        let formatValidation = self.formatConfigurations
            .map { $0.isEnabled }
            .contains(true)
        if formatValidation == false {
            throw .missingFormat
        }

        // Check our seed
        if self.seed <= 0 {
            throw .missingSeed
        }

        // Check our TopK
        if self.topK <= 0 {
            throw .missingTopK
        }

        // Check our TopP
        if self.topP < 0 || self.topP > 1 {
            throw .invalidTopP
        }

        // Check our ContextLength
        if self.contextLength <= 0 {
            throw .missingContextLength
        }

        // Check our BatchSize
        if self.batchSize <= 0 {
            throw .missingBatchSize
        }

        // Check our MaxTokenCount
        if self.maxTokenCount <= 0 {
            throw .missingMaxTokenCount
        }

        // Check our SystemPrompt
        if self.systemPrompt.isEmpty {
            throw .missingSystemPrompt
        }
    }

    /// Saves the current configuration and persists changes to the database.
    ///
    /// - Parameter showResyncWarnings: A flag to determine whether resync warnings
    /// should be displayed.
    func save(showResyncWarnings: Bool = true) async {
        do {
            // Ensure we have a valid form
            try self.checkFormValidation()

            // Do we need to warn the user of a full-resync?
            if self.resyncNeeded && showResyncWarnings {
                if let message = self.resyncMessage {
                    self.alertConfiguration = .init(
                        title: L10n.ConfigureProject.Resync.title,
                        message: message,
                        primaryAction: .init(
                            title: L10n.ConfigureProject.Resync.saveButton
                        ) {
                            await self.save(
                                showResyncWarnings: false
                            )
                        }
                    )
                    return
                }
            }

            // Insert the Project into the DB
            let project = try self.finalisedProject()
            let inserted = try await self.persist(project: project)
            let projectID = try inserted.id.orThrow(
                Project.ProjectError.missingID
            )

            // Insert the ProjectSettings into the DB
            let settings = try self.finalisedSettings(for: projectID)
            _ = try await self.persist(settings: settings)

            await MainActor.run {
                // Let our caller know that we've saved our settings
                self.onSave?()

                // Close this current window
                self.onDismiss.send(())

                // Open the Window with the project that we just inserted, if creating
                if self.configureType == .creating {
                    self.onOpen.send(
                        .project(
                            .init(project: inserted)
                        )
                    )
                }
            }
        } catch {
            logService.log(with: .error, "Failed to persist: \(error)")

            let errorTitle = switch self.configureType {
            case .creating:
                L10n.Error.ConfigureProject.Creating.FailedToCreate.title
            case .editing:
                L10n.Error.ConfigureProject.Editing.FailedToCreate.title
            }

            await MainActor.run {
                self.alertConfiguration = .init(
                    title: errorTitle,
                    message: error.description
                )
            }
        }

    }

} // swiftlint:disable:this file_length
