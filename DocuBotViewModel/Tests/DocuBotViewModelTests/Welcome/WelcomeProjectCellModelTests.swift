//
//  WelcomeProjectCellModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

class WelcomeProjectCellModelTests {

    // MARK: - Properties

    private var selectedProject: Project?

    // MARK: - Tests

    @Test("Initialisation")
    func initialisation() {
        let project = Project.mock()

        // GIVEN we have a WelcomeProjectCellModel with a project
        let testSubject = WelcomeProjectCellModel(project: project)

        // THEN the project is set correctly
        #expect(testSubject.project == project)
    }

    @Test("Identifier")
    func identifier() throws {
        let project = Project.mock()

        // GIVEN we have a WelcomeProjectCellModel with a project
        let testSubject = WelcomeProjectCellModel(project: project)

        // THEN the ID is set correctly
        let projectID = try #require(project.id)
        #expect(testSubject.id == projectID)
    }

    @Test("Equality")
    func equality() {
        let project1 = Project.mock()
        let project2 = Project.mock()

        // GIVEN we have two WelcomeProjectCellModels
        let testSubject1 = WelcomeProjectCellModel(project: project1)
        let testSubject2 = WelcomeProjectCellModel(project: project2)

        // THEN they should be equal
        #expect(testSubject1 == testSubject2)
    }

    @Test("Inequality")
    func inequality() {
        let project1 = Project.mock(id: 1)
        let project2 = Project.mock(id: 2)

        // GIVEN we have two WelcomeProjectCellModels
        let testSubject1 = WelcomeProjectCellModel(project: project1)
        let testSubject2 = WelcomeProjectCellModel(project: project2)

        // THEN they should NOT be equal
        #expect(testSubject1 != testSubject2)
    }

    @Test("Labels")
    func labels() {
        let project = Project.mock(
            path: "/path/to/file",
            name: "Cool Project"
        )

        // GIVEN we have a WelcomeProjectCellModel with a project
        let testSubject = WelcomeProjectCellModel(project: project)

        // THEN the labels are setup correctly
        #expect(testSubject.title == "Cool Project")
        #expect(testSubject.subtitle == "/path/to/file")
        #expect(testSubject.openButton.symbol == .arrowForwardCircle)
        #expect(testSubject.openButton.hoverSymbol == .arrowForwardCircleFill)
    }

    @Test("Open Project Delegate")
    func openProjectDelegate() {

        let project = Project.mock()

        // GIVEN we have a WelcomeProjectCellModel
        let testSubject = WelcomeProjectCellModel(project: project, delegate: self)

        // WHEN the open button is selected
        testSubject.openButton.selected()

        // THEN the delegate function is called correctly
        #expect(self.selectedProject == project)
    }

}

// MARK: - WelcomeProjectCellViewModelDelegate

extension WelcomeProjectCellModelTests: WelcomeProjectCellViewModelDelegate {

    func openProject(_ project: Project) {
        self.selectedProject = project
    }

}
