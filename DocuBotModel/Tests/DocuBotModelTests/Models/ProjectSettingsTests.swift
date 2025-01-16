//
//  ProjectSettingsTests.swift
//  DocuBotModel
//
//  Created by William Lumley on 17/11/2024.
//

@testable import DocuBotModel
import Testing

struct ProjectSettingsTests {

    // MARK: - Types

    typealias Format = ProjectSettings.DocumentationFormat

    // MARK: - Tests

    @Test("Is Enabled")
    func isEnabled() {
        let formats: [Format] = [
            .rtf,
            .txt,
            .other("foo"),
            .other("bar")
        ]

        // GIVEN we have a settings with various supported formats
        let settings = ProjectSettings.mock(supportedFormats: formats)

        // WHEN we check to see if various types are within the supported format
        // THEN we get the expected results back
        #expect(settings.isEnabled(.rtf) == true)
        #expect(settings.isEnabled(.txt) == true)
        #expect(settings.isEnabled(.html) == false)
        #expect(settings.isEnabled(.md) == false)
        #expect(settings.isEnabled(.other("foo")) == true)
        #expect(settings.isEnabled(.other("bar")) == true)
        #expect(settings.isEnabled(.other("foobar")) == false)
    }

    @Test("Other Formats")
    func otherFormats() {
        let formats: [Format] = [
            .rtf,
            .html,
            .md,
            .txt,
            .other("foo"),
            .other("bar")
        ]

        // GIVEN we have a settings with various supported formats
        let settings = ProjectSettings.mock(supportedFormats: formats)

        // WHEN we pull out the `otherFormats`
        let otherFormats = settings.otherFormats

        // THEN only the `otherFormats` are present
        #expect(otherFormats == [
            .other("foo"),
            .other("bar")
        ])
    }

    @Test("Equality")
    func equality() {
        // GIVEN we have two equal settings
        let equalSettings1 = ProjectSettings.mock()
        let equalSettings2 = ProjectSettings.mock()

        // THEN they should be seen as equal
        #expect(equalSettings1 == equalSettings2)

        // GIVEN we have two unequal settings
        let unequalSettings1 = ProjectSettings.mock(systemPrompt: "foo")
        let unequalSettings2 = ProjectSettings.mock(systemPrompt: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalSettings1 != unequalSettings2)
    }

    @Test("Equality Ignoring ID")
    func equalityIgnoringID() {
        // GIVEN we have two equal settings
        let equalSettings1 = ProjectSettings.mock()
        let equalSettings2 = ProjectSettings.mock()

        // THEN they should be seen as equal
        #expect(equalSettings1 == equalSettings2)

        // GIVEN we have two unequal settings
        let unequalSettings1 = ProjectSettings.mock(systemPrompt: "foo")
        let unequalSettings2 = ProjectSettings.mock(systemPrompt: "bar")

        // THEN they should NOT be seen as equal
        #expect(unequalSettings1.isEqualToIgnoringID(unequalSettings2) == false)

        // GIVEN we have two equal documents apart from ID
        let settings1 = ProjectSettings.mock(id: 1)
        let settings2 = ProjectSettings.mock(id: 2)

        // THEN they should be seen as equal ignoring ID
        #expect(settings1.isEqualToIgnoringID(settings2))
    }

    @Test("Format Initialising from Raw Value")
    func initFromRawValue() {
        #expect(Format(rawValue: "rtf") == .rtf)
        #expect(Format(rawValue: "html") == .html)
        #expect(Format(rawValue: "txt") == .txt)
        #expect(Format(rawValue: "md") == .md)
        #expect(Format(rawValue: "foobar") == .other("foobar"))
    }

    @Test("Format Extension Name")
    func formatExtensionName() {
        // GIVEN we have the formats
        let rtf = Format.rtf
        let html = Format.html
        let md = Format.md
        let txt = Format.txt
        let other = Format.other("foo")

        // WHEN we check their `extensionName`
        // THEN it's returning the correct value
        #expect(rtf.extensionName == "rtf")
        #expect(html.extensionName == "html")
        #expect(md.extensionName == "md")
        #expect(txt.extensionName == "txt")
        #expect(other.extensionName == "foo")
    }

    @Test("Format Is Other")
    func formatIsOther() {
        // GIVEN we have the formats
        let rtf = Format.rtf
        let html = Format.html
        let md = Format.md
        let txt = Format.txt
        let other = Format.other("foo")

        // WHEN we check their `isOther` state
        // THEN it's returning the correct value
        #expect(rtf.isOther == false)
        #expect(html.isOther == false)
        #expect(md.isOther == false)
        #expect(txt.isOther == false)
        #expect(other.isOther == true)
    }

    @Test("Language Identifiable")
    func languageIdentifiableTests() {
        // GIVEN a language
        let language = ProjectSettings.Language.english

        // WHEN accessing the id
        let languageID = language.id

        // THEN the id matches the language itself
        #expect(languageID == language)
    }

}
