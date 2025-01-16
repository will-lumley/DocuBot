//
//  MenuButtonViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing

@Suite("MenuButtonViewModelTests", .tags(.toolbox))
struct MenuButtonViewModelTests {

    @Test("Initialisation")
    func initialisation() {
        // GIVEN a MenuButtonViewModel
        let testSubject = MenuButtonViewModel(text: "Test Button") {}

        // THEN the properties are set correctly
        #expect(testSubject.text == "Test Button")
        #expect(testSubject.isEnabled == true)
    }

    @Test("Default OnSelect")
    func defaultOnSelect() {
        // GIVEN a MenuButtonViewModel with a default onSelect closure
        let testSubject = MenuButtonViewModel(text: "Test Button")

        // WHEN the selected method is called
        testSubject.selected()

        // THEN no action occurs (no crash indicates success)
        #expect(true) // Dummy expectation to ensure test runs
    }

    @Test("OnSelect Action")
    func onSelectAction() {
        var actionExecuted = false

        // GIVEN a MenuButtonViewModel with a custom onSelect closure
        let testSubject = MenuButtonViewModel(text: "Test Button") {
            actionExecuted = true
        }

        // WHEN the selected method is called
        testSubject.selected()

        // THEN the action is executed
        #expect(actionExecuted == true)
    }

    @Test("Property Updates")
    func propertyUpdates() {
        // GIVEN a MenuButtonViewModel
        let testSubject = MenuButtonViewModel(text: "Initial Text")

        // WHEN properties are updated
        testSubject.text = "Updated Text"
        testSubject.isEnabled = false

        // THEN the updates are reflected
        #expect(testSubject.text == "Updated Text")
        #expect(testSubject.isEnabled == false)
    }

}
