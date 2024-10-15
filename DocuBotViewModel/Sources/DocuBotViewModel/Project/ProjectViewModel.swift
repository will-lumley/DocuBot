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

    public enum OpenWindow {
        case settings(ProjectSettingsViewModel.OpenWindowPackage)
    }

    public typealias OnDelete = () -> Void

    // MARK: - Properties

    /// This will be called when we want to open a new window, along with the info that dictates which window
    @Published public var onOpen = PassthroughSubject<OpenWindow, Never>()

    @Published public var chatText = "What is the difference between the SIT and Demo environment?"

    /// The project that we're focussing on within this ViewModel
    private var project: Project

    // MARK: - Lifecycle

    public init(project: Project, serviceContainer: ServiceContainer) {
        self.project = project
        super.init(serviceContainer: serviceContainer)
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
                let settings = try await persistenceService.getProjectSettings(for: project)
                DispatchQueue.main.async {
                    self.onOpen.send(
                        .settings(
                            .init(project: self.project, projectSettings: settings)
                        )
                    )
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func enterSelected() {
        print("ENTER")
    }

}

// MARK: - Private

private extension ProjectViewModel {

    func sync() {
        Task {
            do {
                // Pull out the settings
                let settings = try await persistenceService.getProjectSettings(
                    for: project
                )

                // Setup our DocumentBuilder
                let documentBuilder = DocumentParser(self.project, settings)

                // Parse through the Documents
                let result = try await documentBuilder.createAndParse()

                // Persist the result
                self.project.documentationChecksum = result.checksum
                try await self.persistProject()
                try await self.persist(documents: result.documents)
            } catch DocumentParser.DocumentError.bookmarkIsStale {
                self.project.urlBookmarkDataIsStale = true
                try await self.persistProject()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func persistProject() async throws {
        _ = try await persistenceService.update(project: project)
    }

    func persist(documents: [Document]) async throws {
        // Delete all the pre-existing documents
        let toBeDeleted = try await persistenceService.getDocuments(for: self.project)
        _ = try await persistenceService.delete(documents: toBeDeleted)

        // Insert all the new ones
        let persisted = try await persistenceService.insert(documents: documents)
        self.project.load(documents: persisted)
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
                urlBookmarkDataIsStale: true,
                createdAt: .now,
                updatedAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
