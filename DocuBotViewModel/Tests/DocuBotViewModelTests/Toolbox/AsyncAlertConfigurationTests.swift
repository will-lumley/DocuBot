//
//  AlertConfigurationTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing

@Suite("AsyncAlertConfigurationTests", .tags(.toolbox))
struct AsyncAlertConfigurationTests {

    @Test("Initialisation")
    func initialisation() throws {
        // GIVEN we have an AlertConfiguration
        let testSubject = AsyncAlertConfiguration(title: "title", message: "message")

        // THEN the values are set correctly
        #expect(testSubject.title == "title")
        #expect(testSubject.message == "message")
    }

    @Test("Primary Action")
    func primaryAction() async {
        var primaryActionSelected = false

        // GIVEN we have an AlertConfiguration
        let testSubject = AsyncAlertConfiguration(
            title: "",
            message: "",
            primaryAction: .init(
                title: "press me"
            ) {
                primaryActionSelected = true
            }
        )

        // WHEN we select the primary action
        await testSubject.primaryAction?.onSelect()

        // THEN the primary action was called
        #expect(primaryActionSelected == true)
    }

    @Test("ID Creation with No Action")
    func idCreationWithNoAction() {
        // GIVEN we have an AlertConfiguration
        let testSubject = AsyncAlertConfiguration(
            title: "title",
            message: "message",
            primaryAction: .init(
                title: "this is an action",
                onSelect: { }
            )
        )

        // THEN the ID is set correctly
        #expect(testSubject.id == "titlemessagethis is an action")
    }

    @Test("ID Creation with Action")
    func idCreationWithAction() {
        // GIVEN we have an AlertConfiguration
        let testSubject = AsyncAlertConfiguration(
            title: "title",
            message: "message"
        )

        // THEN the ID is set correctly
        #expect(testSubject.id == "titlemessage")
    }

    @Test("Equality")
    func equality() {
        // GIVEN we have an AlertConfiguration
        let testSubject1 = AsyncAlertConfiguration(title: "title", message: "message")
        let testSubject2 = AsyncAlertConfiguration(title: "title", message: "message")

        // THEN the equality is correctly set
        #expect(testSubject1 == testSubject2)
    }

    @Test("Inequality")
    func inequality() {
        // GIVEN we have an AlertConfiguration
        let testSubject1 = AsyncAlertConfiguration(title: "title1", message: "message")
        let testSubject2 = AsyncAlertConfiguration(title: "title", message: "message2")

        // THEN the equality is correctly set
        #expect(testSubject1 != testSubject2)
    }

}
