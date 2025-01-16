//
//  ContextMenuConfigurationTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import Testing

@Suite("ContextMenuConfigurationTests", .tags(.toolbox))
struct ContextMenuConfigurationTests {

    @Test("Initialisation")
    func initialisation() {
        var actionExecuted = false

        // GIVEN we have a ContextMenuConfiguration
        let testSubject = ContextMenuConfiguration(
            text: "Option 1"
        ) {
            actionExecuted = true
        }

        // THEN the values are set correctly
        #expect(testSubject.text == "Option 1")
        #expect(actionExecuted == false)
    }

    @Test("OnSelect Action")
    func onSelectAction() {
        var actionExecuted = false

        // GIVEN we have a ContextMenuConfiguration
        let testSubject = ContextMenuConfiguration(
            text: "Option 1"
        ) {
            actionExecuted = true
        }

        // WHEN the onSelect action is called
        testSubject.onSelect()

        // THEN the action is executed
        #expect(actionExecuted == true)
    }

    @Test("ID Creation")
    func idCreation() {
        // GIVEN we have a ContextMenuConfiguration
        let testSubject = ContextMenuConfiguration(
            text: "Unique Text"
        ) {}

        // THEN the ID is set correctly
        #expect(testSubject.id == "Unique Text")
    }

    @Test("Equality")
    func equality() {
        // GIVEN we have two ContextMenuConfiguration instances with the same text
        let configuration1 = ContextMenuConfiguration(
            text: "Same Text"
        ) {}

        let configuration2 = ContextMenuConfiguration(
            text: "Same Text"
        ) {}

        // THEN they should be equal
        #expect(configuration1 == configuration2)
    }

    @Test("Hashing")
    func hashing() {
        // GIVEN we have two ContextMenuConfiguration instances with the same text
        let configuration1 = ContextMenuConfiguration(
            text: "Same Text"
        ) {}

        let configuration2 = ContextMenuConfiguration(
            text: "Same Text"
        ) {}

        // WHEN we create their hashes
        var hasher1 = Hasher()
        configuration1.hash(into: &hasher1)
        let hash1 = hasher1.finalize()

        var hasher2 = Hasher()
        configuration2.hash(into: &hasher2)
        let hash2 = hasher2.finalize()

        // THEN their hashes should be equal
        #expect(hash1 == hash2)
    }

    @Test("Non-Equality")
    func nonEquality() {
        // GIVEN we have two ContextMenuConfiguration instances with different text
        let configuration1 = ContextMenuConfiguration(
            text: "Text A"
        ) {}

        let configuration2 = ContextMenuConfiguration(
            text: "Text B"
        ) {}

        // THEN they should not be equal
        #expect(configuration1 != configuration2)
    }

}
