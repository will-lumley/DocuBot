//
//  ProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class ProjectViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// This is a struct that contains the information used to open this view
    /// (ie. the `ProjectView`) itself.
    public struct OpenWindowPackage: Hashable, Codable {
         public let project: Project
    }

    public struct Progress: Hashable, Sendable {
        public let value: Int
        public let total: Int
    }

    public enum SyncStage: Hashable, Sendable {
        case extractingDocumentsFromDisk
        case trainingDocuments(project: Project, progress: Progress)
        case buildingExampleQuestions(project: Project, progress: Progress)
    }

    // MARK: - Properties

    /// The text our user is asking
    @Published public var chatText = ""

    /// The text our LLM has responded back with
    @Published public var responseText = ""

    /// The project that we're focussing on within this ViewModel
    @Published private var project: Project

    /// The syncing stage of our project
    @Published public var syncStage: SyncStage?

    /// The ViewModels that make up our example questions
    @Published public var questionViewModels = [ProjectQuestionViewModel]()

    /// Our "settings" ViewModel for this project
    @Published public var configureProjectViewModel: ConfigureProjectViewModel?

    /// This is used to create or close a generic `Alert`
    @Published public var alertConfiguration: AlertConfiguration?

    /// This fires when we need to request the UI level to request folder permissions
    public let triggerFolderAccessRequest = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project
        super.init(serviceContainer: serviceContainer)

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
            .assign(to: &$questionViewModels)
    }

}

// MARK: - Public

public extension ProjectViewModel {

    var openSettingsButton: ToolbarButtonViewModel {
        .init(symbol: .gear) {
            self.openSettings()
        }
    }

    var syncProjectButton: ToolbarButtonViewModel {
        .init(symbol: .arrowTriangle2Circlepath) {
            self.sync()
        }
    }

    var windowTitle: String {
        self.project.name
    }

    var queryTitle: String {
        L10n.Project.queryTitle
    }

    func openSettings() {
        Task {
            do {
                let settings = try await self.getProjectSettings()
                DispatchQueue.main.async {
                    self.configureProjectViewModel = .init(
                        projectInfo: .init(project: self.project, settings: settings),
                        serviceContainer: self.serviceContainer
                    )
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
        Task {
            do {
                let query = self.chatText
                let settings = try await self.getProjectSettings()

                // Get the documents that are most relevant to this query
                let documents = try await self.fetchRelevantDocumentation(with: query)

                // Create a polished query with our relevant documents in tow
                let formattedQuery = self.createQuery(with: documents, for: query)

                logService.log(with: .info, "Query: \(query)")
                logService.log(with: .info, "Formatted Query:\n\n \(formattedQuery)\n")

                // Shoot it over to the LLM
                let response = try await self.gptService.respond(
                    to: formattedQuery,
                    with: settings.systemPrompt
                ) { update in
                    self.logService.log(with: .info, "Update: \(update)")
                    self.responseText += update
                }
                self.logService.log(with: .info, "Response: \(response)")
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

    func exampleQuestionSelected(_ question: String) {
        self.chatText = question
    }

    func directorySelected(_ directory: URL?) {
        guard let directory else {
            return
        }

        let bookmarkData = try? directory.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        self.project.isDirty = true
        self.project.path = directory.path
        self.project.urlBookmarkData = bookmarkData

        Task {
            do {
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
                        DispatchQueue.main.async {
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
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                // Update the project properties
                DispatchQueue.main.sync {
                    self.project.documentationChecksum = result.checksum
                    self.project.exampleQuestions = exampleQuestions
                }

                // Persist the Project and Documents
                try await self.persistProject()
                try await self.persist(documents: documents)

                // Let the user interact with the UI again
                DispatchQueue.main.async {
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
    ) async throws -> [String] {
        let project = try await self.getProject(fetchDocuments: true)
        let settings = try await self.getProjectSettings()

        let results = try await project.fetchRelevantDocumentation(
            for: message,
            with: settings
        )

        return results
            .prefix(3)
            .map(\.text)

//        // Pull out the IDs of our documents
//        let ids = results.compactMap { result -> Int64? in
//            guard let idStr = result.metadata["id"] else {
//                return nil
//            }
//            return Int64(idStr)
//        }
//
//        let documents = try await persistenceService.getDocuments(ids: ids)
//        return documents
    }

    func createQuery(with documents: [String], for query: String) -> String {
        let sources = documents.joined(separator: "\n\n")
        return L10n.Project.LlmQueryPrompt.template(query, sources)
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

    var progress: ProjectViewModel.Progress? {
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
                isDirty: false,
                urlBookmarkData: nil,
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
