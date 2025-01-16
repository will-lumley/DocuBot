//
//  ProjectSettings.DocumentationFormat+ViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

struct ProjectSettingsDocumentationFormatTests {

    // MARK: - Types

    typealias Format = ProjectSettings.DocumentationFormat

    // MARK: - Tests

    @Test("Name")
    func name() {
        #expect(Format.rtf.name == ".rtf")
        #expect(Format.txt.name == ".txt")
        #expect(Format.html.name == ".html")
        #expect(Format.md.name == ".md")
        #expect(Format.other("foo").name == "Other")
    }

    @Test("Other Str")
    func otherStr() {
        #expect(Format.other("foo").otherStr == "foo")
        #expect(Format.other("bar").otherStr == "bar")
    }

}
