//
//  SourceCellModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import AppKit
import DocuBotModel
@testable import DocuBotViewModel
import Foundation
import Testing

@Suite("SourceCellModelTests", .tags(.view))
class SourceCellModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Labels")
    func labels() throws {
        // GIVEN we have a SourceCellModel
        let testSubject = SourceCellModel(
            document: .mock(
                url: URL(filePath: "/path/to/cool_file.md")
            ),
            score: 0.45
        )

        // THEN our labels are setup correctly
        #expect(testSubject.title == "cool_file.md")
        #expect(testSubject.subtitle == "/path/to/cool_file.md")
        #expect(testSubject.scoreDescription == "45%")
        #expect(testSubject.url == URL(filePath: "/path/to/cool_file.md"))
    }

    @Test("Context Menu Items")
    func contextMenuItems() async throws {
        self.swizzleWorkspaceFileViewing()

        // GIVEN we have a SourceCellModel
        let testSubject = SourceCellModel(
            document: .mock(
                url: URL(filePath: "/path/to/cool_file.md")
            ),
            score: 0.45
        )

        // THEN our context menu configurations are set correctly
        #expect(
            testSubject.contextMenuConfigurations == [
                .init(text: "Show in Finder") { }
            ]
        )

        // WHEN the context menu is selected
        testSubject.contextMenuConfigurations.first?.onSelect()
        try await Task.sleep(for: .seconds(2.0))

        // THEN the opened file path is correct
        let viewedFile = try #require(self.viewedFiles?.first)
        #expect(viewedFile == URL(filePath: "/path/to/cool_file.md"))
    }

    @Test("Identifiable")
    func id() {
        // GIVEN we have a SourceCellModel with a Document ID of 42
        let testSubject = SourceCellModel(
            document: .mock(
                id: 42
            ),
            score: 0.45
        )

        // THEN it inherit's the document ID
        #expect(testSubject.id == 42)
    }

    @Test("Should Show Score - Default")
    func shouldShowScoreDefault() {
        // GIVEN we have a SourceCellModel with no Delegate
        let testSubject = SourceCellModel(
            document: .mock(),
            score: 0.45,
            delegate: nil
        )

        // THEN the `shouldShowScore` value defaults to false
        #expect(testSubject.shouldShowScore == false)
    }

    @Test("Should Show Score - True")
    func shouldShowScoreTrue() {

        class TestClass: SourceCellModelDelegate {
            func shouldShowScore() -> Bool {
                return true
            }
        }

        // GIVEN we have a SourceCellModel with a Delegate
        let testSubject = SourceCellModel(
            document: .mock(),
            score: 0.45,
            delegate: TestClass()
        )

        // THEN the `shouldShowScore` value is true
        #expect(testSubject.shouldShowScore == true)
    }

    @Test("Should Show Score - False")
    func shouldShowScoreFalse() {

        class TestClass: SourceCellModelDelegate {
            func shouldShowScore() -> Bool {
                return false
            }
        }

        // GIVEN we have a SourceCellModel with a Delegate
        let testSubject = SourceCellModel(
            document: .mock(),
            score: 0.45,
            delegate: TestClass()
        )

        // THEN the `shouldShowScore` value is true
        #expect(testSubject.shouldShowScore == false)
    }

}
