//
//  ProjectTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Testing

struct ProjectTests {

    @Test("Loading Documents")
    func loadingDocuments() {
        // GIVEN we have a project
        var project = Project.mock()

        // THEN it has no documents
        #expect(project.loadedDocuments == false)

        // WHEN we load the documents into the project
        project.load(documents: [.mock()])

        // THEN we have documents
        #expect(project.loadedDocuments)
    }

    @Test("Set Alert Status")
    func setAlertStatus() {
        // GIVEN we have a project with no alert status
        var project = Project.mock(alertStatus: .none)

        // WHEN we apply isDirty status to the project
        project.set(alertStatus: .warning(warning: .isDirty))

        // THEN the project's alert status is isDirty
        #expect(project.alertStatus == .warning(warning: .isDirty))

        // WHEN we apply metricChanged status to the project
        project.set(alertStatus: .warning(warning: .metricChanged))

        // THEN the project's alert status is metricChanged
        #expect(project.alertStatus == .warning(warning: .metricChanged))

        // WHEN we apply modelChanged status to the project
        project.set(alertStatus: .warning(warning: .modelChanged))

        // THEN the project's alert status is modelChanged
        #expect(project.alertStatus == .warning(warning: .modelChanged))

        // WHEN we apply formatsChanged status to the project
        project.set(alertStatus: .warning(warning: .formatsChanged))

        // THEN the project's alert status is formatsChanged
        #expect(project.alertStatus == .warning(warning: .formatsChanged))

        // WHEN we apply directoryChanged status to the project
        project.set(alertStatus: .warning(warning: .directoryChanged))

        // THEN the project's alert status is directoryChanged
        #expect(project.alertStatus == .warning(warning: .directoryChanged))

        // WHEN we apply firstSync status to the project
        project.set(alertStatus: .error(error: .firstSync))

        // THEN the project's alert status is firstSync
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we try and downgrade from firstSync to isDirty
        project.set(alertStatus: .warning(warning: .isDirty))

        // THEN the change isn't processed because it's lower priority
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we try and downgrade from firstSync to metricChanged
        project.set(alertStatus: .warning(warning: .metricChanged))

        // THEN the change isn't processed because it's lower priority
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we try and downgrade from firstSync to modelChanged
        project.set(alertStatus: .warning(warning: .modelChanged))

        // THEN the change isn't processed because it's lower priority
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we try and downgrade from firstSync to formatsChanged
        project.set(alertStatus: .warning(warning: .formatsChanged))

        // THEN the change isn't processed because it's lower priority
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we try and downgrade from firstSync to directoryChanged
        project.set(alertStatus: .warning(warning: .directoryChanged))

        // THEN the change isn't processed because it's lower priority
        #expect(project.alertStatus == .error(error: .firstSync))

        // WHEN we want to clear out any alert status from our project
        project.set(alertStatus: .none)

        // THEN that is processed
        #expect(project.alertStatus == .none)
    }

    @Test("Clear Dirty Status")
    func clearDirtyStatus() {
        // GIVEN we have a project with no alert status
        var project = Project.mock(alertStatus: .none)

        // WHEN we apply metricChanged status to the project
        project.set(alertStatus: .warning(warning: .metricChanged))

        // THEN the alert status is metricChanged
        #expect(project.alertStatus == .warning(warning: .metricChanged))

        // WHEN we clear the dirty status
        project.clearDirtyStatus()

        // THEN our status remains unchanged
        #expect(project.alertStatus == .warning(warning: .metricChanged))

        // WHEN we update our status to isDirty
        project.set(alertStatus: .none)
        project.set(alertStatus: .warning(warning: .isDirty))

        // THEN the project's alert status is isDirty
        #expect(project.alertStatus == .warning(warning: .isDirty))

        // WHEN we clear the dirty status
        project.clearDirtyStatus()

        // THEN our dirty status is cleared
        #expect(project.alertStatus == .none)
    }

    @Test("Equality")
    func equality() {
        // GIVEN we have two equal projects
        let equalProject1 = Project.mock()
        let equalProject2 = Project.mock()

        // THEN they should be seen as equal
        #expect(equalProject1 == equalProject2)

        // GIVEN we have two unequal projects
        let unequalProject1 = Project.mock(name: "foo")
        let unequalProject2 = Project.mock(name: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalProject1 != unequalProject2)
    }

    @Test("Equality Ignoring ID")
    func equalityIgnoringID() {
        // GIVEN we have two equal projects
        let equalProject1 = Project.mock()
        let equalProject2 = Project.mock()

        // THEN they should be seen as equal
        #expect(equalProject1 == equalProject2)

        // GIVEN we have two unequal projects
        let unequalProject1 = Project.mock(name: "foo")
        let unequalProject2 = Project.mock(name: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalProject1.isEqualToIgnoringID(unequalProject2) == false)

        // GIVEN we have two equal documents apart from ID
        let project1 = Project.mock(id: 1)
        let project2 = Project.mock(id: 2)

        // THEN they should be seen as equal ignoring ID
        #expect(project1.isEqualToIgnoringID(project2))
    }

    @Test("ProjectError Description")
    func projectErrorDescription() {
        // GIVEN we have a missingID error
        let error = Project.ProjectError.missingID

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Project.missingID)
    }

    @Test("NoDocumentsFound Description")
    func noDocumentsFoundErrorDescription() {
        // GIVEN we have a documentFetchError error
        let error = Project.DocumentFetchError.noDocumentsFound

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Project.DocumentFetch.noDocumentsFound)
    }

    @Test("NoDocumentsFound Description")
    func noIndexingErrorDescription() {
        // GIVEN we have a noIndexing error
        let error = Project.DocumentFetchError.noIndexing

        // WHEN we pull out the description
        let description = error.errorDescription

        // THEN it's correctly set
        #expect(description == L10n.Error.Project.DocumentFetch.noIndexing)
    }

}
