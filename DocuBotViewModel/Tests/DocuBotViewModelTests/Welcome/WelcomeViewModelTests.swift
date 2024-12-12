//
//  WelcomeViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import Combine
import DocuBotModel
import DocuBotService
@testable import DocuBotViewModel
import Foundation
import Testing

// swiftlint:disable line_length

class WelcomeViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Tests

    @Test("Labels")
    func labels() {
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        #expect(testSubject.title == "Welcome to DocuBot")
        #expect(testSubject.subtitle1 == "Developed by William Lumley")
        #expect(testSubject.subtitle2.starts(with: "v"))
        #expect(testSubject.subtitle2.contains("("))
        #expect(testSubject.subtitle2.contains(")"))
    }

    @Test("Close Button")
    func closeButton() async {
        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        // THEN our CloseButton should look as expected
        #expect(testSubject.closeButton.symbol == .xmarkCircle)
        #expect(testSubject.closeButton.hoverSymbol == .xmarkCircleFill)

        // THEN the onDismiss closure is called
        await confirmation { confirmation in
            testSubject.onDismiss
                .sink { _ in
                    confirmation()
                }
                .store(in: &cancellables)

            // WHEN the close button is selected
            testSubject.closeButton.selected()
        }
    }

    @Test("New Project Button")
    func newProjectButton() async throws {
        await self.persistTestModel()

        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        // THEN the NewProject button is correctly set
        #expect(testSubject.newProjectButton.text == "Load New Project")

        // WHEN the New Project button is selected
        testSubject.newProjectButton.selected()

        // THEN the ConfigureProjectViewModel is loaded
        let configureProjectViewModel = try await testSubject
            .$configureProjectViewModel
            .firstValue()

        // THEN the ConfigureProjectViewModel is for a new project
        #expect(configureProjectViewModel?.projectInfo == nil)
    }

    @Test("View Source Code Button")
    func viewSourceCodeButton() async throws {
        self.swizzleWorkspaceOpen()

        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        // THEN the View Code button is correctly set
        #expect(testSubject.viewSourceCodeButton.text == "View Source Code")

        // WHEN the View Code button is selected
        testSubject.viewSourceCodeButton.selected()

        // THEN the ConfigureProjectViewModel is loaded
        let configureProjectViewModel = try await testSubject
            .$configureProjectViewModel
            .firstValue()

        // THEN the ConfigureProjectViewModel is for a new project
        #expect(configureProjectViewModel?.projectInfo == nil)
    }

    @MainActor
    @Test("Email Developer Button")
    func emailDeveloperButton() throws {
        self.swizzleSharingServicePerform()

        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        // THEN the Email Developer button is correctly set
        #expect(testSubject.emailDeveloperButton.text == "Email the Developer")

        // WHEN the Email Developer button is selected
        testSubject.emailDeveloperButton.selected()

        // THEN the share action happened
        let shareItem = try #require(self.sharedItem)

        // THEN the share happened to the right email address
        #expect(shareItem.recipients == ["will@lumley.io"])

        // THEN the share content was blank
        let items = try #require(shareItem.items as? [String])
        #expect(items == [""])
    }

    @Test("Open Model Manager Button")
    func openModelManagerButton() async {
        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(serviceContainer: serviceContainer)

        // THEN the Open Model Manager button is correctly set
        #expect(testSubject.openModelManagerButton.text == "Open Model Manager")

        // WHEN the Open Model Manager button is selected
        let package = await confirmation { confirmation in
            var package: WelcomeViewModel.OpenWindow?
            testSubject.onOpen
                .sink { newPackage in
                    package = newPackage
                    confirmation()
                }
                .store(in: &cancellables)

            // WHEN the Open Model Manager button is selected
            testSubject.openModelManagerButton.selected()
            return package
        }

        // THEN the Model Manager is opened
        #expect(package == .modelManager)
    }

    @Test("Delete Model Confirmation Dialogue")
    func deleteModelDialogue() async throws {
        var deleteActionCalled = false

        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(
            serviceContainer: serviceContainer
        )
        testSubject.deleteProjectAction = {
            deleteActionCalled = true
        }

        // WHEN we create our Delete Confirmation
        let deleteConfirmation = testSubject.deleteProjectConfirmationDialog

        // THEN it's titles and buttons are set correctly
        #expect(deleteConfirmation.title == "Are you sure you want to delete this project?")
        #expect(
            deleteConfirmation.buttons == [
                .init(title: "Delete this Project", role: .destructive, action: { }),
                .init(title: "Cancel", role: .cancel, action: { })
            ]
        )

        // WHEN we call the action
        await deleteConfirmation.buttons
            .first { $0.role == .destructive }?
            .action()

        // THEN our delete action is called
        #expect(deleteActionCalled == true)
    }

    @Test("Context Menu Items")
    func contextMenuItems() async throws {
        self.swizzleWorkspaceFileViewing()

        // GIVEN we have a Project in the DB
        var project = Project.mock()
        project = try await persistenceService.insert(project: project)

        // GIVEN we have a WelcomeViewModel
        let testSubject = WelcomeViewModel(
            serviceContainer: serviceContainer
        )

        let row = WelcomeProjectCellModel(project: project)
        let contextMenuConfigurations = testSubject.contextMenuConfigurations(for: row)

        // THEN our context menu configurations are set correctly
        #expect(
            contextMenuConfigurations == [
                .init(text: "Open") { },
                .init(text: "Delete") { },
                .init(text: "Show in Finder") { }
            ]
        )

        // WHEN the ShowInFinder button is selected
        contextMenuConfigurations[2].onSelect()
        try await Task.sleep(for: .seconds(2.0))

        // THEN the opened file path is correct
        let viewedFile = try #require(self.viewedFiles?.first)
        #expect(viewedFile == URL(filePath: "/Users/will/Desktop/Project_1"))

        // WHEN the Open button is selected
        let package = await confirmation { confirmation in
            var package: WelcomeViewModel.OpenWindow?
            testSubject.onOpen
                .sink { newPackage in
                    package = newPackage
                    confirmation()
                }
                .store(in: &cancellables)

            // WHEN the Open is selected
            contextMenuConfigurations[0].onSelect()
            return package
        }

        // THEN a new window is opened with the Project in question
        #expect(package == .project(.init(project: project)))

        // WHEN the Delete button is selected
        contextMenuConfigurations[1].onSelect()

        // THEN the delete confirmation dialog is presented
        #expect(testSubject.deleteProjectConfirmationDialogPresented == true)

        // WHEN the user selects cancel on the delete model confirmation
        await testSubject.deleteProjectConfirmationDialog.buttons
            .first { $0.role == .destructive }?
            .action()

        // THEN the Project has been deleted
        await #expect(throws: PersistenceError.valueNotFound) {
            try await persistenceService.getProject(
                id: try #require(project.id)
            )
        }
    }

    @Test("List State - No Models")
    func noModelListState() async {
        typealias ListViewState = WelcomeViewModel.ListViewState

        // GIVEN we have a WelcomeViewModel, and no Models in the DB
        let testSubject = WelcomeViewModel(
            serviceContainer: serviceContainer
        )

        // Create an iterator to get our values over time
        var iteratorListView = testSubject.$listState.values.makeAsyncIterator()

        // THEN the ListState is .none
        #expect(await iteratorListView.next() == ListViewState.none)

        // THEN the second ListState is .noModels
        guard case .noModels(let configuration) = await iteratorListView.next() else {
            Issue.record("ListState is of type: \(testSubject.listState)")
            return
        }

        // THEN the empty configuration matches up
        #expect(configuration.title == "Download a Model to get started")
        #expect(configuration.subtitle == "Choose a model to enable DocuBot's AI features and start exploring your documentation.")
        #expect(configuration.icon == .arrowDownDoc)
        #expect(configuration.action?.title == "Open Model Manager")

        let package = await confirmation { confirmation in
            var package: WelcomeViewModel.OpenWindow?
            testSubject.onOpen
                .sink { newPackage in
                    package = newPackage
                    confirmation()
                }
                .store(in: &cancellables)

            // WHEN we select the EmptyConfiguration action
            configuration.action?.onSelect()
            return package
        }

        // THEN the ModelManager is opened
        #expect(package == .modelManager)
    }

    @Test("List State - No Projects")
    func noProjectsListState() async throws {
        typealias ListViewState = WelcomeViewModel.ListViewState

        await self.persistTestModel()

        // GIVEN we have a WelcomeViewModel, with Models in the DB
        let testSubject = WelcomeViewModel(
            serviceContainer: serviceContainer
        )

        // Create an iterator to get our values over time
        var iteratorListView = testSubject.$listState.values.makeAsyncIterator()

        // THEN the ListState is .none
        #expect(await iteratorListView.next() == ListViewState.none)

        // THEN the second ListState is .noProjects
        guard case .noProjects(let configuration) = await iteratorListView.next() else {
            Issue.record("ListState is of type: \(testSubject.listState)")
            return
        }

        // THEN the empty configuration matches up
        #expect(configuration.title == "Your project list is empty")
        #expect(configuration.subtitle == "Your insights await – load a new project to get started")
        #expect(configuration.icon == .booksVerticalFill)
        #expect(configuration.action?.title == "Load New Project")

        // WHEN we select the EmptyConfiguration action
        configuration.action?.onSelect()

        var iterator = testSubject.$configureProjectViewModel
            .values
            .makeAsyncIterator()

        // THEN the ConfigureProject sheet is opened
        let configureProjectViewModel = try #require(await iterator.next())

        // THEN the ConfigureProject has no existing project
        #expect(configureProjectViewModel?.projectInfo == nil)
    }

    @Test("List State - Projects")
    func projectsListState() async throws {
        typealias ListViewState = WelcomeViewModel.ListViewState

        await self.persistTestModel()

        var project1 = Project.mock(id: 1)
        var project2 = Project.mock(id: 2)

        project1 = try await persistenceService.insert(project: project1)
        project2 = try await persistenceService.insert(project: project2)

        // GIVEN we have a WelcomeViewModel, with Models and Projects in the DB
        let testSubject = WelcomeViewModel(
            serviceContainer: serviceContainer
        )

        // Create an iterator to get our values over time
        var iteratorListView = testSubject.$listState.values.makeAsyncIterator()

        // THEN the ListState is .none
        #expect(await iteratorListView.next() == ListViewState.none)

        // THEN the ListState is .projects
        guard case .listProjects(let cells) = await iteratorListView.next() else {
            Issue.record("ListState is of type: \(testSubject.listState)")
            return
        }

        // THEN the cells we have in our ListState represent
        // our Projects we inserted into the DB
        #expect(
            cells == [
                .init(project: project1),
                .init(project: project2)
            ]
        )
    }

}

// swiftlint:enable line_length
