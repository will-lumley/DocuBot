//
//  ConfirmationDialogConfigurationTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing

struct ConfirmationDialogConfigurationTests {

    @Test("Initialisation")
    func initialisation() throws {
        // GIVEN we have a ConfirmationDialogConfiguration with no buttons
        let testSubject = ConfirmationDialogConfiguration(
            title: "Dialog Title",
            buttons: []
        )

        // THEN the values are set correctly
        #expect(testSubject.title == "Dialog Title")
        #expect(testSubject.buttons.isEmpty == true)
    }

    @Test("Button Initialisation")
    func buttonInitialisation() {
        // GIVEN we have a ButtonConfiguration
        let testSubject = ConfirmationDialogConfiguration.ButtonConfiguration(
            title: "Delete",
            role: .destructive
        ) {}

        // THEN the values are set correctly
        #expect(testSubject.title == "Delete")
        #expect(testSubject.role == .destructive)
    }

    @Test("Button Action")
    func buttonAction() {
        var buttonPressed = false

        // GIVEN we have a ButtonConfiguration
        let button = ConfirmationDialogConfiguration.ButtonConfiguration(
            title: "Press Me",
            role: .cancel
        ) {
            buttonPressed = true
        }

        // WHEN we perform the button action
        button.action()

        // THEN the button action was called
        #expect(buttonPressed == true)
    }

    @Test("Dialog ID")
    func dialogID() {
        // GIVEN we have a ConfirmationDialogConfiguration
        let testSubject = ConfirmationDialogConfiguration(
            title: "Dialog Title",
            buttons: []
        )

        // THEN the ID is set correctly
        #expect(testSubject.id == "Dialog Title")
    }

    @Test("Button ID")
    func buttonID() {
        // GIVEN we have a ButtonConfiguration
        let button = ConfirmationDialogConfiguration.ButtonConfiguration(
            title: "Cancel",
            role: .cancel
        ) {}

        // THEN the ID is set correctly
        #expect(button.id == "Cancelcancel")
    }

    @Test("Dialog with Multiple Buttons")
    func dialogWithMultipleButtons() {
        // GIVEN we have a ConfirmationDialogConfiguration with multiple buttons
        let button1 = ConfirmationDialogConfiguration.ButtonConfiguration(
            title: "Delete",
            role: .destructive
        ) {}

        let button2 = ConfirmationDialogConfiguration.ButtonConfiguration(
            title: "Cancel",
            role: .cancel
        ) {}

        let testSubject = ConfirmationDialogConfiguration(
            title: "Dialog Title",
            buttons: [button1, button2]
        )

        // THEN the dialog contains the correct number of buttons
        #expect(testSubject.buttons.count == 2)
        #expect(testSubject.buttons[0].title == "Delete")
        #expect(testSubject.buttons[1].title == "Cancel")
    }

}
