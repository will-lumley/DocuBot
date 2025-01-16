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

/// A ViewModel for managing the lifecycle, interactions, and state of a project within the DocuBot application.
public class ProjectViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// A package containing information required to open the `ProjectView`.
    public struct OpenWindowPackage: Hashable, Codable {
        /// The project to be opened.
        public let project: Project
    }

    /// Represents the response status for a user query.
    public enum ResponseStatus: Hashable, Sendable {
        /// No response has been initiated.
        case none
        /// The system is processing the request.
        case loading
        /// A response has been received.
        case response(response: String)
    }

    /// Represents the synchronization stage of a project.
    public enum SyncStage: Hashable, Sendable {
        /// Extracting documents from disk.
        case extractingDocumentsFromDisk
        /// Training documents with progress tracking.
        case trainingDocuments(project: Project, progress: DocuBotToolbox.Progress)
        /// Building example questions with progress tracking.
        case buildingExampleQuestions(project: Project, progress: DocuBotToolbox.Progress)
    }

    // MARK: - Properties

    /// The text input by the user for querying.
    @Published public var chatText = ""

    /// The content to be shared when the user selects the Share button.
    @Published public var shareContent: String?

    /// The response status of the query.
    @Published public var response = ResponseStatus.none

    /// Indicates whether the system is waiting for a response.
    @Published public var expectingResponse = false

    /// Controls the enablement of the text field.
    @Published public var disableTextField = false

    /// The project currently being managed by this ViewModel.
    @Published private var project: Project

    /// The current synchronization stage of the project.
    @Published public var syncStage: SyncStage?

    /// The list of example questions as ViewModels.
    @Published public var questions = [ProjectQuestionViewModel]()

    /// Indicates whether the sources view is displayed.
    @Published public var isShowingSources = false

    /// The ViewModel managing the sources content.
    @Published public var sources: SourcesViewModel?

    /// The settings ViewModel for configuring the project.
    @Published public var configureProjectViewModel: ConfigureProjectViewModel?

    /// Configuration for the alert displayed to the user.
    @Published public var alertConfiguration: AlertConfiguration?

    /// Toolbar button for displaying the list of sources.
    @Published public var sourcesButton: ToolbarButtonViewModel

    /// Toolbar button for syncing the project.
    @Published public var syncProjectButton: ToolbarButtonViewModel

    /// Toolbar button for accessing project settings.
    @Published public var projectSettingsButton: ToolbarButtonViewModel

    /// The alert status of the project being viewed.
    @Published public var alertStatus: Project.AlertStatus?

    /// The title of the Ask/Cancel button.
    @Published public var askButtonTitle = L10n.Project.QueryButton.Ask.title

    /// The icon for the Ask/Cancel button.
    @Published public var askButtonIcon: SFSymbol = .playFill

    /// Indicates whether the Share button is disabled.
    @Published public var shareButtonDisabled = false

    /// A publisher that triggers folder access requests.
    public let triggerFolderAccessRequest = PassthroughSubject<Void, Never>()

    /// The task currently executing a query.
    private var currentTask: Task<(), Never>?

    // MARK: - Lifecycle

    /// Initializes a new `ProjectViewModel`.
    ///
    /// - Parameters:
    ///   - project: The project managed by this ViewModel.
    ///   - serviceContainer: The service container providing shared services.
    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project

        self.sourcesButton = .init(
            name: L10n.Project.Toolbar.sources,
            symbol: .docTextMagnifyingglass,
            isEnabled: false
        )
        self.syncProjectButton = .init(
            name: L10n.Project.Toolbar.sync,
            symbol: .arrowTriangle2Circlepath
        )
        self.projectSettingsButton = .init(
            name: L10n.Project.Toolbar.settings,
            symbol: .gear
        )

        super.init(serviceContainer: serviceContainer)

        self.sourcesButton.onSelect = { [weak self] in self?.isShowingSources.toggle() }
        self.syncProjectButton.onSelect = self.sync
        self.projectSettingsButton.onSelect = self.openSettings

        if project.alertStatus.isFirstSync {
            self.sync()
        }

        // Every x seconds we check if the project is dirty
        self.checkIfProjectIsDirty()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkIfProjectIsDirty()
        }

        self.primeLlm()
    }

    /// Configures bindings for the ViewModel.
    override public func configureBindings() {
        super.configureBindings()

        // Anytime our project changes on the DB, bubble it up to our VM layer
        persistenceService.getProject(id: self.project.id ?? -1)
            .assign(to: &$project)

        // Convert the project example questions into ViewModels
        self.$project
            .map(\.exampleQuestions)
            .map { questions in
                questions.map { question in
                    ProjectQuestionViewModel(content: question) {
                        self.exampleQuestionSelected($0)
                    }
                }
            }
            .assign(to: &$questions)

        // If we have an alert status, update the sync buttons icon to have an "!"
        self.$project
            .map(\.alertStatus)
            .map { $0 != .none }
            .map { isAlert -> SFSymbol in
                isAlert ? . exclamationmarkArrowTriangle2Circlepath : .arrowTriangle2Circlepath
            }
            .assign(to: \.symbol, on: syncProjectButton)
            .store(in: &cancellables)

        // If we have an alert status, tell the user
        self.$project
            .map(\.alertStatus)
            .assign(to: &$alertStatus)

        // Set the SyncButton to the appropriate colour
        self.$project
            .map(\.alertStatus)
            .map(ToolbarButtonViewModel.WarningState.init)
            .assign(to: \.warningState, on: syncProjectButton)
            .store(in: &cancellables)

        // Enable the ViewSources button if we have any sources
        // AND we're not syncing
        Publishers.CombineLatest(self.$sources, self.$syncStage)
            .map { sources, syncStage in
                return sources != nil && syncStage == .none
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: sourcesButton)
            .store(in: &cancellables)

        // Disable the SyncButton if we're syncing
        self.$syncStage
            .map { $0 == .none }
            .removeDuplicates()
            .assign(to: \.isEnabled, on: syncProjectButton)
            .store(in: &cancellables)

        // Disable the Settings button if we're syncing
        self.$syncStage
            .map { $0 == .none }
            .removeDuplicates()
            .assign(to: \.isEnabled, on: projectSettingsButton)
            .store(in: &cancellables)

        // Disable the TextField if we're expecting a response
        // OR
        // we have an error
        Publishers.CombineLatest($expectingResponse, $project)
            .map { $0 == true || $1.alertStatus.isError }
            .removeDuplicates()
            .assign(to: &$disableTextField)

        // Set the Ask button to say "Ask" if we are NOT expecting a response
        // Set the Ask button to say "Stop" if we are expecting a response
        self.$expectingResponse
            .map {
                if $0 {
                    return L10n.Project.QueryButton.Cancel.title
                } else {
                    return L10n.Project.QueryButton.Ask.title
                }
            }
            .removeDuplicates()
            .assign(to: &$askButtonTitle)

        // Set the Ask button to say "Stop" if we are expecting a response
        self.$expectingResponse
            .map {
                if $0 {
                    return SFSymbol.stopFill
                } else {
                    return SFSymbol.playFill
                }
            }
            .removeDuplicates()
            .assign(to: &$askButtonIcon)

        // If we do NOT have ShareContent
        // OR
        // We are currently NOT waiting for the LLM to get back to us
        // We disable our button
        Publishers.CombineLatest(self.$shareContent, self.$expectingResponse)
            .map { $0 == nil || $1 == true }
            .removeDuplicates()
            .assign(to: &$shareButtonDisabled)

        // If we have a response, we can share it
        self.$response
            .compactMap { response -> String? in
                switch response {
                case .response(let value):
                    return value
                default:
                    return nil
                }
            }
            .assign(to: &$shareContent)
    }

}

// MARK: - Public

public extension ProjectViewModel {

    /// The title for the window displaying this project.
    var windowTitle: String {
        self.project.name
    }

    /// The title for the query input section.
    var queryTitle: String {
        L10n.Project.queryTitle
    }

    /// The placeholder text for the query text editor.
    var textEditorPlaceholder: String {
        L10n.Project.placeholder
    }

    /// The title for the Share button.
    var shareButtonTitle: String {
        L10n.Project.ShareButton.title
    }

    /// Handles the selection of the settings button.
    func openSettings() {
        Task {
            do {
                let settings = try await self.getProjectSettings()
                let allModels = try await persistenceService.getModels()
                let model = try await persistenceService.getModel(
                    id: settings.modelID
                )

                await MainActor.run {
                    self.configureProjectViewModel = .init(
                        projectInfo: .init(
                            project: self.project,
                            settings: settings,
                            model: model
                        ),
                        availableModels: allModels,
                        serviceContainer: self.serviceContainer,
                        onSave: self.primeLlm
                    )
                }
            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToExtractData.title,
                        message: error.description
                    )
                }
            }
        }
    }

    /// Handles the selection of an example question.
    ///
    /// - Parameter question: The example question selected by the user.
    func exampleQuestionSelected(_ question: String) {
        self.chatText = question
    }

    /// Updates the project's directory and persists the changes.
    ///
    /// - Parameter directory: The URL of the new directory. If `nil`, an error is thrown.
    ///
    /// - Discussion:
    /// This function sets the project's directory, updates the bookmark data for the directory,
    /// and marks the project with a `directoryChanged` alert status. It then attempts to persist
    /// the updated project configuration. If an error occurs, an alert is displayed to the user.
    func directorySelected(_ directory: URL?) {
        Task {
            do {
                guard let directory else {
                    throw ConfigureProjectViewModel.FormValidationError.missingDirectory
                }

                let bookmarkData = try directory.bookmarkData(
                    options: .securityScopeAllowOnlyReadAccess,
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )

                self.project.set(
                    alertStatus: .warning(warning: .directoryChanged)
                )
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

    /// Handles the selection of the Ask/Cancel button.
    ///
    /// - Discussion:
    /// If the system is currently expecting a response (indicating a query is in progress), this
    /// function cancels the ongoing task and stops the GPT service. Otherwise, it initiates the
    /// query process by calling `parseQuestion()`.
    func askButtonSelected() {
        if self.expectingResponse {
            self.currentTask?.cancel()
            gptService.stop()

            self.response = .none
            self.expectingResponse = false
        } else {
            self.parseQuestion()
        }
    }

}

// MARK: - Private

private extension ProjectViewModel {

    /// Parses the user query and generates a response using the configured LLM and relevant project documents.
    ///
    /// - Discussion:
    /// This function retrieves the most relevant project documents based on the user's query.
    /// It formats the query with the document data and sends it to the LLM for processing.
    /// The response is then updated in the ViewModel.
    ///
    /// - Workflow:
    /// 1. Fetch relevant documents and their metadata.
    /// 2. Format the query based on the project's settings.
    /// 3. Process the query using the LLM.
    /// 4. Handle and display the response or update alerts on errors.
    func parseQuestion() {
        self.response = .loading
        self.expectingResponse = true

        self.currentTask = Task {
            defer {
                self.expectingResponse = false
            }

            do {
                let query = self.chatText
                let settings = try await self.getProjectSettings()

                let limitCount = preferenceStoreService.documentPrefixCount

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
                let documentScores = zip(documents, similarityScores)

                // Configure our sources
                await MainActor.run { [unowned self] in
                    self.sources = SourcesViewModel(
                        sources: documentScores.map { documentWithScore in
                            let document = documentWithScore.0
                            let score = documentWithScore.1
                            return SourceCellModel(
                                document: document,
                                score: score,
                                delegate: self
                            )
                        },
                        serviceContainer: serviceContainer
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

                    await MainActor.run {
                        self.response = .response(response: response)
                    }

                } else {
                    // Create a polished query with our relevant documents in tow
                    let formattedQuery = self.createQuery(
                        with: sources,
                        for: query
                    )

                    logService.log(with: .info, "Query: \(query)")
                    logService.log(with: .info, "Formatted Query:\n\(formattedQuery)\n")

                    // Shoot it over to the LLM
                    let response = try await self.gptService.respond(
                        to: formattedQuery,
                        with: settings.systemPrompt
                    ) { update in
                        guard self.expectingResponse else {
                            return
                        }
                        self.response = .response(response: update)
                    }
                    self.logService.log(with: .info, "Response: \(response)")
                }

            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.GptTalk.title,
                        message: error.description
                    )
                }
            }
        }
    }

    /// Checks if the project's state has been modified and updates the project's alert status.
    ///
    /// - Discussion:
    /// This function compares the project's current state with its stored state to determine if changes have
    /// occurred (e.g., changes in documents or settings). If the project is "dirty," it updates the alert status
    /// to warn the user.
    ///
    /// - Workflow:
    /// 1. Fetch the project's settings.
    /// 2. Use `DocumentParser` to compare the current state with stored data.
    /// 3. Update the alert status if discrepancies are found.
    /// 4. Persist the updated project state.
    func checkIfProjectIsDirty() {
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
                    onSyncUpdate: { _, _ in }
                )
                // Are we dirty?
                let isDirty = try await documentBuilder.checkProjectIsDirty()
                logService.log(with: .info, "Project Dirty: \(isDirty)")

                // If we are, persist it to the DB
                await MainActor.run {
                    if isDirty {
                        self.project.set(alertStatus: .warning(warning: .isDirty))
                    } else {
                        self.project.clearDirtyStatus()
                    }
                }
                try await self.persistProject()

            } catch {
                logService.log(with: .error, "Failed to check project. \(error.description)")

                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToCheckProject.title,
                        message: error.description
                    )
                }
            }
        }
    }

    /// Configures the LLM with the project's settings and associated model.
    ///
    /// - Discussion:
    /// This function prepares the LLM by providing it with the necessary configurations and models for
    /// processing user queries.
    ///
    /// - Workflow:
    /// 1. Retrieve the project's settings and model.
    /// 2. Configure the LLM with the retrieved data.
    /// 3. Handle any errors that occur during the priming process by displaying alerts.
    func primeLlm() {
        Task {
            do {
                // Prime our LLM with our settings
                let settings = try await self.getProjectSettings()
                let model = try await persistenceService.getModel(
                    id: settings.modelID
                )

                try gptService.prime(
                    with: model,
                    with: settings
                )
            } catch {
                self.alertConfiguration = .init(
                    title: L10n.Error.Project.FailedToStartLlm.title,
                    message: error.description
                )
            }
        }
    }

    /// Synchronizes the project by extracting documents, training them, and building example questions.
    ///
    /// - Discussion:
    /// This function manages the synchronization process, which involves parsing documents from the
    /// project directory, analyzing them, and updating the project state with example questions.
    ///
    /// - Workflow:
    /// 1. Fetch project settings and existing documents.
    /// 2. Parse documents using `DocumentParser`.
    /// 3. Generate example questions.
    /// 4. Update and persist the project's state.
    func sync() {
        self.syncStage = .extractingDocumentsFromDisk

        Task {
            do {
                // After we've done everything, we want the `syncStage`
                // to go back to `nil`
                defer {
                    Task { await MainActor.run { self.syncStage = nil } }
                }

                // Pull out the settings
                let settings = try await persistenceService.getProjectSettings(
                    for: project
                )

                // Pull out the documents
                let existingDocuments = try await persistenceService.getDocuments(
                    for: project
                )
                await MainActor.run {
                    self.project.load(documents: existingDocuments)
                }

                // Setup our DocumentBuilder
                let documentBuilder = DocumentParser(
                    project: self.project,
                    settings: settings,
                    onSyncUpdate: { progress, total in
                        DispatchQueue.main.async {
                            self.syncStage = .trainingDocuments(
                                project: self.project,
                                progress: .init(
                                    value: Double(progress),
                                    total: Double(total)
                                )
                            )
                        }
                    }
                )

                // Parse through the Documents
                let result = try await documentBuilder.createAndParse()
                let documents = result.documents

                // Build our example questions
                let exampleQuestions = try await buildExampleQuestions(
                    from: documents,
                    with: settings
                )

                // Update the project properties
                DispatchQueue.main.sync {
                    self.project.set(alertStatus: .none)
                    self.project.documentationChecksum = result.checksum
                    self.project.exampleQuestions = exampleQuestions
                }

                // Persist the Project and Documents
                try await self.persistProject()
                try await self.persist(documents: documents)
            } catch let error as DocumentParser.DocumentError {
                logService.log(with: .error, "Failed to sync. \(error.description)")

                // If we're here this means our bookmark data is stale/non-existent
                await MainActor.run {
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
                    self.alertConfiguration = .init(
                        title: L10n.Error.Project.FailedToSync.title,
                        message: error.description
                    )
                }
            }
        }
    }

    /// Persists the current state of the project to the database.
    ///
    /// - Throws: An error if the persistence process fails.
    func persistProject() async throws {
        _ = try await persistenceService.update(project: self.project)
    }

    /// Persists the given documents to the database after deleting existing ones.
    ///
    /// - Parameter documents: The list of documents to be persisted.
    /// - Throws: An error if the persistence process fails.
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

    /// Retrieves the project's current state, optionally including its associated documents.
    ///
    /// - Parameter fetchDocuments: A flag indicating whether to fetch associated documents.
    /// - Returns: The project's current state.
    /// - Throws: An error if the project retrieval process fails.
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

    /// Retrieves the project's settings from the database.
    ///
    /// - Returns: The project's settings.
    /// - Throws: An error if the settings retrieval process fails.
    func getProjectSettings() async throws -> ProjectSettings {
        return try await persistenceService.getProjectSettings(
            for: self.project
        )
    }

    /// Searches for the most relevant documents for the given query.
    ///
    /// - Parameter message: The user's query string.
    /// - Returns: A list of relevant documents with similarity scores.
    /// - Throws: An error if the document retrieval process fails.
    func fetchRelevantDocumentation(
        with message: String
    ) async throws -> [SimilarityIndex.SearchResult] {
        let project = try await self.getProject(fetchDocuments: true)
        let settings = try await self.getProjectSettings()
        let floor = preferenceStoreService.similarityFloorScore

        let results = try await project.fetchRelevantDocumentation(
            for: message,
            with: settings,
            with: floor
        )
        return results
    }

    /// Formats a query string with the content of relevant documents.
    ///
    /// - Parameters:
    ///   - documents: The list of document content to include in the query.
    ///   - query: The user's query string.
    /// - Returns: A formatted query string.
    func createQuery(with documents: [String], for query: String) -> String {
        let sources = documents.joined(separator: "\n\n")
        return L10n.Project.LlmQueryPrompt.template(sources, query)
    }

    /// Generates example questions based on the project's documents.
    ///
    /// - Parameters:
    ///   - documents: The list of documents to use for generating questions.
    ///   - settings: The project's settings.
    /// - Returns: A list of example questions.
    /// - Throws: An error if the question generation process fails.
    func buildExampleQuestions(
        from documents: [Document],
        with settings: ProjectSettings
    ) async throws -> [String] {
        // Create the example questions.
        // Ideally this would be done on the Model layer,
        // however due to the fact that we're using GPTService
        // to create the questions, we're unable to do so.
        let totalQuestions     = preferenceStoreService.numberOfExampleQuestions
        var completedQuestions = 0

        // We'll pull 10 random documents from the project
        // Pull out their content
        // Trim the content to a maximum length of 150 characters
        // Put the trimmed content into a prompt template for our LLM
        // Query the LLM with our prompt
        // Filter out any nils
        // Tidy up any decorations the LLM can put on
        return await documents
            .shuffled()
            .prefix(totalQuestions)
            .map(\.content)
            .map { $0.trim(by: 150) }
            .map { L10n.Project.LlmExampleQuestionPrompt.prompt($0) }
            .asyncMap { prompt in
                let progress = Progress(
                    value: Double(completedQuestions),
                    total: Double(totalQuestions)
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
                logService.log(
                    with: .info,
                    "Built question: \(String(describing: question))"
                )

                return question
            }
            .compactMap(\.self)
            // .map { $0.removingLeading(patttern: "* ") }
            .map { $0.removing(value: "Question:") }
            .map { $0.removing(value: ", according to the provided excerpt") }
            .map { $0.removing(value: "according to the provided excerpt") }
            .map { $0.removing(value: ", according to the provided documentation") }
            .map { $0.removing(value: "according to the provided documentation") }
            .map { $0.removing(value: ", in the given context") }
            .map { $0.removing(value: "in the given context") }
            .map { $0.removing(value: "<|eot_id|>") }
            .map { $0.removingPrefix(upTo: ":\n") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

}

// MARK: - ToolbarButtonViewModel.WarningState

private extension ToolbarButtonViewModel.WarningState {

    /// Initializes a `ToolbarButtonViewModel.WarningState` based on a project's alert status.
    ///
    /// - Parameter alertStatus: The current alert status of the project, indicating whether there is
    /// no alert (`none`), a warning, or an error.
    init(alertStatus: Project.AlertStatus) {
        switch alertStatus {
        case .none:
            self = .none
        case .warning:
            self = .warning
        case .error:
            self = .error
        }
    }

}

// MARK: - SyncStage

public extension ProjectViewModel.SyncStage {

    /// The title representing the current synchronization stage.
    ///
    /// - Returns: A localized string representing the synchronization stage title.
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

    /// The subtitle providing additional context about the synchronization stage.
    ///
    /// - Returns: A localized string with progress details or additional context.
    var subtitle: String {
        switch self {
        case .extractingDocumentsFromDisk:
            return L10n.Project.SyncStage.ExtractingDocuments.subtitle
        case .trainingDocuments(_, let progress):
            return L10n.Project.SyncStage.TrainingDocuments.subtitle(
                Int(progress.value),
                Int(progress.total)
            )
        case .buildingExampleQuestions(_, let progress):
            return L10n.Project.SyncStage.BuildingQuestions.subtitle(
                Int(progress.value),
                Int(progress.total)
            )
        }
    }

    /// The progress of the current synchronization stage, if applicable.
    ///
    /// - Returns: A `Progress` object tracking the progress of the stage,
    /// or `nil` if progress tracking is not applicable.
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

// MARK: - SourceCellModelDelegate

extension ProjectViewModel: SourceCellModelDelegate {

    /// Determines whether similarity scores should be displayed for source documents.
    ///
    /// - Returns: `true` if similarity scores should be shown; otherwise, `false`.
    public func shouldShowScore() -> Bool {
        return preferenceStoreService.displaySimilarityScoring
    }

} // swiftlint:disable:this file_length
