//
//  HelpConfigurationTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing

struct HelpConfigurationTests {

    @Test("Initialisation")
    func initialisation() {
        var dismissActionExecuted = false

        // GIVEN a HelpConfiguration
        let testSubject = HelpConfiguration(
            title: "Help Title",
            content: "Help Content"
        ) {
            dismissActionExecuted = true
        }

        // THEN the properties are set correctly
        #expect(testSubject.title == "Help Title")
        #expect(testSubject.content == "Help Content")
        #expect(dismissActionExecuted == false)
    }

    @Test("OnDismiss Action")
    func onDismissAction() {
        var dismissActionExecuted = false

        // GIVEN a HelpConfiguration
        let testSubject = HelpConfiguration(
            title: "Help Title",
            content: "Help Content"
        ) {
            dismissActionExecuted = true
        }

        // WHEN the onDismiss action is executed
        testSubject.onDismiss()

        // THEN the action is executed
        #expect(dismissActionExecuted == true)
    }

    @Test("Close Button Action")
    func closeButtonAction() {
        var dismissActionExecuted = false

        // GIVEN a HelpConfiguration with a close button
        let testSubject = HelpConfiguration(
            title: "Help Title",
            content: "Help Content"
        ) {
            dismissActionExecuted = true
        }

        let closeButton = testSubject.closeButton

        // WHEN the close button action is triggered
        closeButton.selected()

        // THEN the onDismiss action is executed
        #expect(dismissActionExecuted == true)
    }

    @Test("ID Creation")
    func idCreation() {
        // GIVEN a HelpConfiguration
        let testSubject = HelpConfiguration(
            title: "Unique Title",
            content: "Unique Content"
        ) {}

        // THEN the ID is set correctly
        #expect(testSubject.id == "Unique TitleUnique Content")
    }

}
