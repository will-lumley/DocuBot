//
//  ProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation
import SFSafeSymbols
import SimilaritySearchKit

public class ProjectViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// This is a struct that contains the information used to open this view
    /// (ie. the `ProjectView`) itself.
    public struct OpenWindowPackage: Hashable, Codable {
         public let project: Project
    }

    public enum ResponseStatus: Hashable, Sendable {
        case none
        case loading
        case response(response: String)
    }

    public enum SyncStage: Hashable, Sendable {
        case extractingDocumentsFromDisk
        case trainingDocuments(project: Project, progress: DocuBotToolbox.Progress)
        case buildingExampleQuestions(project: Project, progress: DocuBotToolbox.Progress)
    }

    // MARK: - Properties

    /// The text our user is asking
    @Published public var chatText = ""

    /// The text our LLM has responded back with
    @Published public var response = ResponseStatus.none

    /// Indicative of if the user is expecting a response or waiting for a response
    @Published public var expectingResponse = false

    /// The project that we're focussing on within this ViewModel
    @Published private var project: Project

    /// The syncing stage of our project
    @Published public var syncStage: SyncStage?

    /// The ViewModels that make up our example questions
    @Published public var questions = [ProjectQuestionViewModel]()

    /// A flag that controls whether we're showing sources to the user or not
    @Published public var isShowingSources = false

    /// The ViewModel that displays our Sources content to the user
    @Published public var sources: SourcesViewModel?

    /// Our "settings" ViewModel for this project
    @Published public var configureProjectViewModel: ConfigureProjectViewModel?

    /// This is used to create or close a generic `Alert`
    @Published public var alertConfiguration: AlertConfiguration?

    /// The button for displaying the list of sources
    @Published public var sourcesButton: ToolbarButtonViewModel

    /// The button for syncing the project
    @Published public var syncProjectButton: ToolbarButtonViewModel

    /// A warning message for the user
    @Published public var warningMessage: String?

    /// This fires when we need to request the UI level to request folder permissions
    public let triggerFolderAccessRequest = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project
        self.sourcesButton = .init(symbol: .docTextMagnifyingglass)
        self.syncProjectButton = .init(symbol: .arrowTriangle2Circlepath)

        super.init(serviceContainer: serviceContainer)

        self.sourcesButton.onSelect = { [weak self] in self?.isShowingSources.toggle() }
        self.syncProjectButton.onSelect = self.sync

        self.primeLlm()
    }

    override public func configureBindings() {
        super.configureBindings()

        // Anytime our project changes on the DB, bubble it up to our VM layer
        persistenceService.getProject(id: self.project.id ?? -1)
            .assign(to: &$project)

        // Convert the project example questions into ViewModels
        self.$project
            .map(\.exampleQuestions)
            .map { $0.shuffled() }
            .map { questions in
                questions.map { question in
                    ProjectQuestionViewModel(content: question) {
                        self.exampleQuestionSelected($0)
                    }
                }
            }
            .assign(to: &$questions)

        // Indicate to the user that we need to sync if the project is dirty
        self.$project
            .map(\.isDirty)
            .map {
                if $0 {
                    SFSymbol.exclamationmarkArrowTriangle2Circlepath
                } else {
                    SFSymbol.arrowTriangle2Circlepath
                }
            }
            .assign(to: \.symbol, on: syncProjectButton)
            .store(in: &cancellables)

        // Indicate to the user that we need to sync if the project is dirty
        self.$project
            .map(\.isDirty)
            .map {
                if $0 {
                    ToolbarButtonViewModel.WarningState.warning
                } else {
                    ToolbarButtonViewModel.WarningState.none
                }
            }
            .assign(to: \.warningState, on: syncProjectButton)
            .store(in: &cancellables)

        // Indicate to the user that we need to sync if the project is dirty
        self.$project
            .map(\.isDirty)
            .map {
                if $0 {
                    L10n.Project.Warning.sync
                } else {
                    nil
                }
            }
            .assign(to: &$warningMessage)

        // Enable the ViewSources button if we have any sources
        self.$sources
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: sourcesButton)
            .store(in: &cancellables)
    }

}

// MARK: - Public

public extension ProjectViewModel {

    var openSettingsButton: ToolbarButtonViewModel {
        .init(symbol: .gear) {
            self.openSettings()
        }
    }

    var windowTitle: String {
        self.project.name
    }

    var queryTitle: String {
        L10n.Project.queryTitle
    }

    var textEditorPlaceholder: String {
        L10n.Project.placeholder
    }

    func openSettings() {
        Task {
            do {
                let settings = try await self.getProjectSettings()
                await MainActor.run {
                    self.configureProjectViewModel = .init(
                        projectInfo: .init(project: self.project, settings: settings),
                        serviceContainer: self.serviceContainer
                    ) {
                        self.primeLlm()
                    }
                }
            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToExtractSettings.title,
                        message: error.description
                    )
                    }
            }
        }
    }

    func enterSelected() {
        self.response = .loading
        self.expectingResponse = true

        Task {
            do {
                let query = self.chatText
                let settings = try await self.getProjectSettings()

                let limitCount = 3

                // Do a search for our most relevant documents
                let results = try await self.fetchRelevantDocumentation(with: query)

                // Get the document IDs
                let documentIDs = results
                    .prefix(limitCount)
                    .map(\.metadata)
                    .compactMap { $0["id"] }
                    .compactMap { Int64($0) }

                // Get the top 3 results and pull out the text itself
                let sources = results
                    .prefix(limitCount)
                    .map(\.text)

                // Get the top 3 similarity scores
                let similarityScores = results
                    .prefix(limitCount)
                    .map(\.score)

                // Pull out the documents themselves
                let documents = try await persistenceService.getDocuments(
                    ids: documentIDs
                )

                // Merge the documents and scores
                let documentsWithScores = zip(documents, similarityScores)

                // Configure our sources
                await MainActor.run {
                    self.sources = SourcesViewModel(
                        sources: documentsWithScores.map { documentWithScore in
                            let document = documentWithScore.0
                            let score = documentWithScore.1
                            return SourceViewModel(document: document, score: score)
                        }
                    )
                }

                if settings.strictMode {
                    // Merge the documents and excerpts
                    let documentsWithExcerpts = zip(documents, sources)

                    // Map the excerpts out into a response format
                    let excerpts = documentsWithExcerpts.map {
                        L10n.Project.StrictMode.sourceTemplate(
                            "\($0.documentTitle)",
                            $1
                        )
                    }

                    var response = L10n.Project.StrictMode.responseTemplate
                    for excerpt in excerpts {
                        response.append(excerpt)
                    }
                    await MainActor.run { self.response = .response(response: response) }

                } else {
                    // Create a polished query with our relevant documents in tow
                    let formattedQuery = self.createQuery(with: sources, for: query)

                    logService.log(with: .info, "Query: \(query)")
                    logService.log(with: .info, "Formatted Query:\n\n \(formattedQuery)\n")

                    // Shoot it over to the LLM
                    let response = try await self.gptService.respond(
                        to: formattedQuery,
                        with: settings.systemPrompt
                    ) { update in
                        guard self.expectingResponse else {
                            return
                        }

                        // If we're not expecting a response, we cna ignore this
                        self.logService.log(with: .info, "Update: \(update)")

                        switch self.response {
                        case .response(let currentResponse):
                            let newText = currentResponse + update
                            self.response = .response(response: newText)
                        default:
                            self.response = .response(response: update)
                        }
                    }
                    await MainActor.run { self.expectingResponse = false }
                    self.logService.log(with: .info, "Response: \(response)")
                }

            } catch {
                await MainActor.run {
                    self.expectingResponse = false
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.GptTalk.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func exampleQuestionSelected(_ question: String) {
        self.chatText = question
    }

    func directorySelected(_ directory: URL?) {
        Task {
            do {
                guard let directory else {
                    throw ConfigureProjectViewModel.ConfigurationError.noDirectory
                }

                let bookmarkData = try directory.bookmarkData(
                    options: .securityScopeAllowOnlyReadAccess,
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )

                self.project.isDirty = true
                self.project.path = directory.path
                self.project.urlBookmarkData = bookmarkData

                try await self.persistProject()
            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.UpdateBookmark.title,
                        message: error.description
                    )
                }
            }
        }
    }

}

// MARK: - Private

private extension ProjectViewModel {

    func primeLlm() {
        Task {
            do {
                // Prime our LLM with our settings
                let settings = try await self.getProjectSettings()
                try gptService.prime(with: settings)
            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToExtractSettings.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func sync() {
        self.syncStage = .extractingDocumentsFromDisk

        Task {
            do {
                // Pull out the settings
                let settings = try await persistenceService.getProjectSettings(
                    for: project
                )

                // Setup our DocumentBuilder
                let documentBuilder = DocumentParser(
                    project: self.project,
                    settings: settings,
                    onSyncUpdate: { progress, total in
                        DispatchQueue.main.async {
                            self.syncStage = .trainingDocuments(
                                project: self.project,
                                progress: .init(value: progress, total: total)
                            )
                        }
                    }
                )

                // Parse through the Documents
                let result = try await documentBuilder.createAndParse()
                let documents = result.documents

                // Create the example questions.
                // Ideally this would be done on the Model layer, however due to the
                // fact that we're using GPTService to create the questions, we're unable to do so.
                let totalQuestions     = 10
                var completedQuestions = 0

                // We'll pull 10 random documents from the project
                // Pull out their content
                // Trim the content to a maximum length of 150 characters
                // Put the trimmed content into a prompt template for our LLM
                // Query the LLM with our prompt
                // Filter out any nils
                // Remove the "Question: " prefix
                let exampleQuestions = await documents.shuffled().prefix(10)
                    .map(\.content)
                    .map { $0.trim(by: 150) }
                    .map { L10n.Project.LlmExampleQuestionPrompt.prompt($0) }
                    .asyncMap { prompt in
                        let progress = Progress(
                            value: completedQuestions,
                            total: totalQuestions
                        )

                        // Update the progress each time a question is created
                        DispatchQueue.main.sync {
                            self.syncStage = .buildingExampleQuestions(
                                project: self.project,
                                progress: progress
                            )
                        }

                        completedQuestions += 1

                        let question = try? await self.gptService.respond(
                            to: prompt,
                            with: settings.systemPrompt,
                            onUpdate: nil
                        )
                        logService.log(with: .info, "Built question: \(String(describing: question))")

                        return question
                    }
                    .compactMap(\.self)
                    .map { $0.replacingOccurrences(of: "Question: ", with: " ") }
                    .map { $0.replacingOccurrences(of: ", according to the provided excerpt?", with: "?") }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                // Update the project properties
                DispatchQueue.main.sync {
                    self.project.isDirty = false
                    self.project.documentationChecksum = result.checksum
                    self.project.exampleQuestions = exampleQuestions
                }

                // Persist the Project and Documents
                try await self.persistProject()
                try await self.persist(documents: documents)

                // Let the user interact with the UI again
                await MainActor.run {
                    self.syncStage = nil
                }
            } catch let error as DocumentParser.DocumentError {
                logService.log(with: .error, "Failed to sync. \(error.description)")

                // If we're here this means our bookmark data is stale/non-existent
                await MainActor.run {
                    self.syncStage = nil

                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.StaleBookmark.title,
                        message: L10n.Error.Project.StaleBookmark.message,
                        primaryAction: .init(
                            title: L10n.Error.Project.StaleBookmark.action
                        ) {
                            self.triggerFolderAccessRequest.send(())
                        }
                    )
                }
            } catch {
                logService.log(with: .error, "Failed to sync. \(error.description)")

                await MainActor.run {
                    self.syncStage = nil

                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToSync.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func persistProject() async throws {
        _ = try await persistenceService.update(project: self.project)
    }

    func persist(documents: [Document]) async throws {
        // Delete all the pre-existing documents
        let toBeDeleted = try await persistenceService.getDocuments(
            for: self.project
        )
        _ = try await persistenceService.delete(documents: toBeDeleted)

        // Insert all the new ones
        let persisted = try await persistenceService.insert(documents: documents)
        await MainActor.run {
            self.project.load(documents: persisted)
        }
    }

    func getProject(fetchDocuments: Bool) async throws -> Project {
        // Fetch the project
        let projectID = try self.project.id.orThrow(Project.ProjectError.missingID)
        var project = try await persistenceService.getProject(id: projectID)

        // If we're not fetching the documents, just return the project
        if fetchDocuments == false {
            return project
        }

        // We are fetching the documents, so pull them up
        let documents = try await persistenceService.getDocuments(for: project)
        project.load(documents: documents)

        return project
    }

    func getProjectSettings() async throws -> ProjectSettings {
        return try await persistenceService.getProjectSettings(
            for: self.project
        )
    }

    func fetchRelevantDocumentation(
        with message: String
    ) async throws -> [SimilarityIndex.SearchResult] {
        let project = try await self.getProject(fetchDocuments: true)
        let settings = try await self.getProjectSettings()

        let results = try await project.fetchRelevantDocumentation(
            for: message,
            with: settings
        )
        return results
    }

    func createQuery(with documents: [String], for query: String) -> String {
        let sources = documents.joined(separator: "\n\n")
        return L10n.Project.LlmQueryPrompt.template(sources, query)
    }

}

// MARK: - SyncStage

public extension ProjectViewModel.SyncStage {

    var title: String {
        switch self {
        case .extractingDocumentsFromDisk:
            return L10n.Project.SyncStage.ExtractingDocuments.title
        case .trainingDocuments(let project, _):
            return L10n.Project.SyncStage.TrainingDocuments.title(project.name)
        case .buildingExampleQuestions:
            return L10n.Project.SyncStage.BuildingQuestions.title
        }
    }

    var subtitle: String {
        switch self {
        case .extractingDocumentsFromDisk:
            return L10n.Project.SyncStage.ExtractingDocuments.subtitle
        case .trainingDocuments(_, let progress):
            return L10n.Project.SyncStage.TrainingDocuments.subtitle(progress.value, progress.total)
        case .buildingExampleQuestions(_, let progress):
            return L10n.Project.SyncStage.BuildingQuestions.subtitle(progress.value, progress.total)
        }
    }

    var progress: DocuBotToolbox.Progress? {
        switch self {
        case .extractingDocumentsFromDisk:
            return nil
        case .trainingDocuments(_, let progress):
            return progress
        case .buildingExampleQuestions(_, let progress):
            return progress
        }
    }

}

// MARK: - Preview

public extension ProjectViewModel {

    static var mock: ProjectViewModel {
        .init(
            project: .init(
                id: 1,
                path: "/Users/will/Desktop/Project_1",
                name: "Project 1",
                urlBookmarkData: .init(),
                documentationCheckSum: "123",
                isDirty: false,
                exampleQuestions: [
                    "Example example example",
                    "Example example example"
                ],
                createdAt: .now,
                updatedAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
