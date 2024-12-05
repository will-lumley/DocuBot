//
//  ModelManagerViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing
import Foundation

class ModelManagerViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Labels")
    func labels() throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // THEN our labels are setup correctly
        #expect(testSubject.windowTitle == "Model Manager")
        #expect(testSubject.downloadMoreButtonTitle == "Find New Models")
    }

    @Test("Delete Model Confirmation Dialogue")
    func deleteModelDialogue() throws {
        var deleteActionCalled = false

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )
        testSubject.deleteModelAction = {
            deleteActionCalled = true
        }

        // WHEN we create our Delete Confirmation
        let deleteConfirmation = testSubject.deleteModelConfirmationDialog

        // THEN it's titles and buttons are set correctly
        #expect(deleteConfirmation.title == "Are you sure you want to delete this model?")
        #expect(
            deleteConfirmation.buttons == [
                .init(title: "Delete this Model", role: .destructive, action: { }),
                .init(title: "Cancel", role: .cancel, action: { })
            ]
        )

        // WHEN we call the action
        deleteConfirmation.buttons
            .first { $0.role == .destructive }?
            .action()

        // THEN our delete action is called
        #expect(deleteActionCalled == true)
    }

    @Test("No Directory Selected")
    func noDirectorySelected() async throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we select no directory
        testSubject.directorySelected(nil)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to get file access",
                message: "No directory selected."
            )
        )
    }

    @Test("Invalid Directory Selected")
    func invalidDirectorySelected() async throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN an invalid URL is selected
        let testURL = URL(fileURLWithPath: "/foo/bar/foobar")
        testSubject.directorySelected(testURL)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to get file access",
                message: "The file “foobar” couldn’t be opened because there is no such file."
            )
        )

    }

    @Test("Directory Selected")
    func directorySelected() throws {
        
    }

    @Test("Minus Button Selected")
    func minusButtonSelected() throws {
        
    }

    @Test("Download More Button Selected")
    func downloadMoreButtonSelected() {
        
    }

    @Test("Progress Title")
    func progressTitle() {
        
    }

    @Test("Progress Subtitle")
    func progressSubtitle() {
        
    }

    @Test("Bytes to GigaBytes")
    func bytesToGigabytes() {
        
    }

    @Test("List State")
    func listState() {
        
    }

}
