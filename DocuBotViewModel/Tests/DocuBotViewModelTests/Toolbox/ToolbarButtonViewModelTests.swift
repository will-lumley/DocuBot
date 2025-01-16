//
//  ToolbarButtonViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import SFSafeSymbols
import Testing

struct ToolbarButtonViewModelTests {

    @Test("Initialisation")
    func initialisation() {
        // GIVEN a ToolbarButtonViewModel
        let testSubject = ToolbarButtonViewModel(
            name: "Test Button",
            symbol: .gear
        ) {}

        // THEN the properties are set correctly
        #expect(testSubject.name == "Test Button")
        #expect(testSubject.symbol == .gear)
        #expect(testSubject.hoverSymbol == nil)
        #expect(testSubject.isEnabled == true)
        #expect(testSubject.warningState == .none)
    }

    @Test("Default OnSelect")
    func defaultOnSelect() {
        // GIVEN a ToolbarButtonViewModel with a default onSelect closure
        let testSubject = ToolbarButtonViewModel(
            name: "Test Button",
            symbol: .gear
        )

        // WHEN the selected method is called
        testSubject.selected()

        // THEN no action occurs (no crash indicates success)
        #expect(true) // Dummy expectation to ensure test runs
    }

    @Test("OnSelect Action")
    func onSelectAction() {
        var actionExecuted = false

        // GIVEN a ToolbarButtonViewModel with a custom onSelect closure
        let testSubject = ToolbarButtonViewModel(
            name: "Test Button",
            symbol: .gear
        ) {
            actionExecuted = true
        }

        // WHEN the selected method is called
        testSubject.selected()

        // THEN the action is executed
        #expect(actionExecuted == true)
    }

    @Test("Property Updates")
    func propertyUpdates() {
        // GIVEN a ToolbarButtonViewModel
        let testSubject = ToolbarButtonViewModel(
            name: "Initial Name",
            symbol: .gear
        )

        // WHEN properties are updated
        testSubject.name = "Updated Name"
        testSubject.symbol = .gearshape
        testSubject.hoverSymbol = .gearshapeFill
        testSubject.isEnabled = false
        testSubject.warningState = .warning

        // THEN the updates are reflected
        #expect(testSubject.name == "Updated Name")
        #expect(testSubject.symbol == .gearshape)
        #expect(testSubject.hoverSymbol == .gearshapeFill)
        #expect(testSubject.isEnabled == false)
        #expect(testSubject.warningState == .warning)
    }

    @Test("Warning States")
    func warningStates() {
        // GIVEN a ToolbarButtonViewModel
        let testSubject = ToolbarButtonViewModel(
            name: "Test Button",
            symbol: .gear
        )

        // WHEN the warningState is updated to .warning and .error
        testSubject.warningState = .warning
        let warningState = testSubject.warningState

        testSubject.warningState = .error
        let errorState = testSubject.warningState

        // THEN the warningState is updated correctly
        #expect(warningState == .warning)
        #expect(errorState == .error)
    }

}
