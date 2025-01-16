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

public class ConfigureProjectViewModel: DocuBotViewModel, Identifiable, @unchecked Sendable {

    // MARK: - Types

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

    public enum OpenWindow: Hashable {
        case project(ProjectViewModel.OpenWindowPackage)
    }

    public enum ConfigureType {
        case creating
        case editing
    }

    public struct FormatConfiguration: Identifiable, Hashable {
        public let order: Int
        public let format: Format
        public let isEnabled: Bool

        public var id: Int {
            self.order
        }
    }

    public struct ProjectInfo {
        public let project: Project
        public let settings: ProjectSettings
        public let model: LLMModel
    }

    public typealias Format = ProjectSettings.DocumentationFormat
    public typealias OnSave = () -> Void

    // MARK: - Properties

    public var id = UUID()

    public let projectInfo: ProjectInfo?

    @Published public var projectDirectory: URL?
    @Published public var projectDirectoryText = ""
    @Published public var projectName = ""
    @Published public var selectedLanguage: ProjectSettings.Language
    @Published public var selectedModel: LLMModel

    @Published public var formatConfigurations: [FormatConfiguration]

    @Published public var systemPrompt: String
    @Published public var embeddingModel: ProjectSettings.EmbeddingModel
    @Published public var similarityMetric: ProjectSettings.SimilarityMetric

    @Published public var seed: Int
    @Published public var topK: Int
    @Published public var topP: Double
    @Published public var contextLength: Int
    @Published public var temperature: Double
    @Published public var batchSize: Int
    @Published public var stopSequence: String?
    @Published public var maxTokenCount: Int
    @Published public var strictMode: Bool

    /// This will be called when the user saves their settings
    var onSave: OnSave?

    /// The encrypted data that makes up the secure directory bookmark
    public var projectDirectoryBookmarkData: Data?

    /// All the embedding models the user can choose from
    public var availableModels = [LLMModel]()

    /// All the languages available for the user to choose from
    public let availableLanguages = ProjectSettings.Language.allCases

    /// All the embedding models the user can choose from
    public let availableEmbeddingModels = ProjectSettings.EmbeddingModel.allCases

    /// All the similarity metric types the user can choose from
    public let availableSimilarityMetrics = ProjectSettings.SimilarityMetric.allCases

    /// This will be called to open a new window, along with the info that dictates which window
    @Published public var onOpen = CurrentValueSubject<OpenWindow?, Never>(nil)

    /// This will be called when this ViewModel wants the UI layer to close the current window
    @Published public var onDismiss = PassthroughSubject<Void, Never>()

    /// This is used to create or close an `Alert`
    @Published public var alertConfiguration: AsyncAlertConfiguration?

    /// This is used to display help information to our user
    @Published public var helpConfiguration: HelpConfiguration?

    // MARK: - Lifecycle

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

    override public func configureBindings() {
        super.configureBindings()

        // When the directory is updated, update the name
        self.$projectDirectory
            .compactMap { $0?.path() }
            .assign(to: &$projectDirectoryText)
    }

}

// MARK: - Public

public extension ConfigureProjectViewModel {

   var formTitle: String {
       switch self.configureType {
       case .creating:
           return L10n.ConfigureProject.Creating.formTitle
       case .editing:
           return L10n.ConfigureProject.Editing.formTitle
       }
    }

    // MARK: Other

    var resetDefaultButtonTitle: String {
        L10n.ConfigureProject.AdvancedSection.resetDefaults
    }

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

    var saveButtonTitle: String {
        switch self.configureType {
        case .creating:
            return L10n.ConfigureProject.Creating.createButton
        case .editing:
            return L10n.ConfigureProject.Editing.createButton
        }
    }

    func saveButtonSelected() async {
        await self.save()
    }

    func helpButtonSelected(with type: HelpType) {
        self.helpConfiguration = .init(type: type) {
            self.helpConfiguration = nil
        }
    }

}

// MARK: - Private

private extension ConfigureProjectViewModel {

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

    var metricChanged: Bool {
        if let projectInfo {
            return projectInfo.settings.similarityMetric != self.similarityMetric
        }
        return false
    }

    var embeddingModelChanged: Bool {
        if let projectInfo {
            return projectInfo.settings.embeddingModel != self.embeddingModel
        }
        return false
    }

    var formatsChanged: Bool {
        if let projectInfo {
            return projectInfo.settings.supportedFormats != self.supportedFormats
        }
        return false
    }

    var directoryChanged: Bool {
        if let projectInfo {
            return self.projectDirectory?.path() != projectInfo.project.path
        }
        return false
    }

    var resyncNeeded: Bool {
        self.metricChanged || self.embeddingModelChanged || self.directoryChanged || self.formatsChanged
    }

    var supportedFormats: [ProjectSettings.DocumentationFormat] {
        self.formatConfigurations
            .filter { $0.isEnabled }
            .map(\.format)
    }

    var configureType: ConfigureType {
        self.projectInfo != nil ? .editing : .creating
    }

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
                needsFullResync: self.resyncNeeded,
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
                needsFullResync: true,
                createdAt: .now,
                updatedAt: .now
            )
        }
    }

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

    // swiftlint:disable:next cyclomatic_complexity
    func checkFormValidation() throws(FormValidationError) {
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

}

// MARK: - Preview

public extension ConfigureProjectViewModel {

    static var mock: ConfigureProjectViewModel {
        .init(
            projectInfo: nil,
            availableModels: [.mock()],
            serviceContainer: .mock
        )
    }

}
