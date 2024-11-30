//
//  IconButtonViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

@testable import DocuBotViewModel
import SFSafeSymbols
import Testing

struct IconButtonViewModelTests {

    @Test("Initialisation")
    func initialisation() {
        // GIVEN an IconButtonViewModel
        let testSubject = IconButtonViewModel(
            symbol: .gear,
            hoverSymbol: .gearshape
        ) {}

        // THEN the properties are set correctly
        #expect(testSubject.symbol == .gear)
        #expect(testSubject.hoverSymbol == .gearshape)
        #expect(testSubject.isEnabled == true)
    }

    @Test("Default OnSelect")
    func defaultOnSelect() {
        // GIVEN an IconButtonViewModel with a default onSelect closure
        let testSubject = IconButtonViewModel(symbol: .gear)

        // WHEN the selected method is called
        testSubject.selected()

        // THEN no action occurs (no crash indicates success)
        #expect(true) // Dummy expectation to ensure test runs
    }

    @Test("OnSelect Action")
    func onSelectAction() {
        var actionExecuted = false

        // GIVEN an IconButtonViewModel with a custom onSelect closure
        let testSubject = IconButtonViewModel(symbol: .gear) {
            actionExecuted = true
        }

        // WHEN the selected method is called
        testSubject.selected()

        // THEN the action is executed
        #expect(actionExecuted == true)
    }

    @Test("Property Updates")
    func propertyUpdates() {
        // GIVEN an IconButtonViewModel
        let testSubject = IconButtonViewModel(symbol: .gear)

        // WHEN properties are updated
        testSubject.symbol = .gearshape
        testSubject.hoverSymbol = .gearshape2
        testSubject.isEnabled = false

        // THEN the updates are reflected
        #expect(testSubject.symbol == .gearshape)
        #expect(testSubject.hoverSymbol == .gearshape2)
        #expect(testSubject.isEnabled == false)
    }

}
