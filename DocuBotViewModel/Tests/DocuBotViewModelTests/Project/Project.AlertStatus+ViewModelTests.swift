//
//  Project.AlertStatus+ViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

// swiftlint:disable line_length

struct ProjectAlertStatusViewModelTests {

    @Test("Title")
    func title() throws {
        #expect(
            Project.AlertStatus.warning(warning: .isDirty).title == "The project's documentation has changed on disk. A sync is required to ensure the latest changes are reflected."
        )

        #expect(
            Project.AlertStatus.warning(warning: .directoryChanged).title == "The project's location has been changed. A sync is required to ensure the latest changes are reflected."
        )

        #expect(
            Project.AlertStatus.warning(warning: .formatsChanged).title == "The project's specified documentation format has been changed. A sync is required to ensure the latest changes are reflected."
        )

        #expect(
            Project.AlertStatus.warning(warning: .metricChanged).title == "The project's similarity metric has been changed. A sync is required to ensure the latest changes are reflected."
        )

        #expect(
            Project.AlertStatus.error(error: .firstSync).title == "This project has not been synced yet. Please perform an initial sync to load and index the project's documentation."
        )
    }

}

// swiftlint:enable line_length
