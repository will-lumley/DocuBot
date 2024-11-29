//
//  EmptyListConfigurationTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing
import SFSafeSymbols

struct EmptyListConfigurationTests {

    @Test("Initialisation")
    func initialisation() {
        // GIVEN an EmptyListConfiguration
        let testSubject = EmptyListConfiguration(
            title: "Test Title",
            subtitle: "Test Subtitle",
            icon: .booksVerticalFill
        )

        // THEN the properties are set correctly
        #expect(testSubject.title == "Test Title")
        #expect(testSubject.subtitle == "Test Subtitle")
        #expect(testSubject.icon == .booksVerticalFill)
        #expect(testSubject.action == nil)
    }

    @Test("Initialisation With Action")
    func initialisationWithAction() {
        var actionExecuted = false

        // GIVEN an EmptyListConfiguration with an action
        let action = EmptyListConfiguration.Action(
            title: "Action Title",
            secondaryTitle: "Secondary Title"
        ) {
            actionExecuted = true
        }

        let testSubject = EmptyListConfiguration(
            title: "Test Title",
            subtitle: "Test Subtitle",
            icon: .booksVerticalFill,
            action: action
        )

        // THEN the properties are set correctly
        #expect(testSubject.title == "Test Title")
        #expect(testSubject.subtitle == "Test Subtitle")
        #expect(testSubject.icon == .booksVerticalFill)
        #expect(testSubject.action?.title == "Action Title")
        #expect(testSubject.action?.secondaryTitle == "Secondary Title")
        #expect(actionExecuted == false)
    }

    @Test("Action Execution")
    func actionExecution() {
        var actionExecuted = false

        // GIVEN an EmptyListConfiguration.Action
        let action = EmptyListConfiguration.Action(
            title: "Action Title",
            secondaryTitle: "Secondary Title"
        ) {
            actionExecuted = true
        }

        // WHEN the action is executed
        action.onSelect()

        // THEN the action is executed
        #expect(actionExecuted == true)
    }

}
