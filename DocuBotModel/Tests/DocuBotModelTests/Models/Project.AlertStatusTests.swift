//
//  Project.AlertStatusTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Testing

struct ProjectAlertStatusTests {

    @Test("Raw Value")
    func rawValue() {
        // Test for .none case
        #expect(Project.AlertStatus.none.rawValue == -1)

        // Test for .warning cases
        #expect(Project.AlertStatus.warning(warning: .isDirty).rawValue == 1)
        #expect(Project.AlertStatus.warning(warning: .metricChanged).rawValue == 2)
        #expect(Project.AlertStatus.warning(warning: .modelChanged).rawValue == 5)
        #expect(Project.AlertStatus.warning(warning: .formatsChanged).rawValue == 6)
        #expect(Project.AlertStatus.warning(warning: .directoryChanged).rawValue == 7)

        // Test for .error cases
        #expect(Project.AlertStatus.error(error: .firstSync).rawValue == 101)
    }

    @Test("Is Error")
    func isError() {
        // Test for .error
        #expect(Project.AlertStatus.error(error: .firstSync).isError)

        // Test for non-error cases
        #expect(Project.AlertStatus.none.isError == false)
        #expect(Project.AlertStatus.warning(warning: .isDirty).isError == false)
        #expect(Project.AlertStatus.warning(warning: .metricChanged).isError == false)
        #expect(Project.AlertStatus.warning(warning: .modelChanged).isError == false)
        #expect(Project.AlertStatus.warning(warning: .formatsChanged).isError == false)
        #expect(Project.AlertStatus.warning(warning: .directoryChanged).isError == false)
    }

    @Test("Is Dirty")
    func isDirty() {
        // Test for .isDirty
        #expect(Project.AlertStatus.warning(warning: .isDirty).isDirty == true)

        // Test for non-dirty cases
        #expect(Project.AlertStatus.none.isDirty == false)
        #expect(Project.AlertStatus.error(error: .firstSync).isDirty == false)
        #expect(Project.AlertStatus.warning(warning: .metricChanged).isDirty == false)
        #expect(Project.AlertStatus.warning(warning: .modelChanged).isDirty == false)
        #expect(Project.AlertStatus.warning(warning: .formatsChanged).isDirty == false)
        #expect(Project.AlertStatus.warning(warning: .directoryChanged).isDirty == false)
    }

    @Test("Is First Sync")
    func isFirstSync() {
        // Test for .firstSync error
        #expect(Project.AlertStatus.error(error: .firstSync).isFirstSync)

        // Test for non-firstSync cases
        #expect(Project.AlertStatus.none.isFirstSync == false)
        #expect(Project.AlertStatus.warning(warning: .metricChanged).isFirstSync == false)
        #expect(Project.AlertStatus.warning(warning: .modelChanged).isFirstSync == false)
        #expect(Project.AlertStatus.warning(warning: .formatsChanged).isFirstSync == false)
        #expect(Project.AlertStatus.warning(warning: .directoryChanged).isFirstSync == false)
    }

}
