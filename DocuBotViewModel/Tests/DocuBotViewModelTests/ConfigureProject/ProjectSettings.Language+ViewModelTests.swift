//
//  ProjectSettings.Language+ViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

struct ProjectLanguageDocumentationFormatTests {

    // MARK: - Types

    typealias Language = ProjectSettings.Language

    // MARK: - Tests

    @Test("Name")
    func name() {
        #expect(Language.english.name == "English")
    }

}
