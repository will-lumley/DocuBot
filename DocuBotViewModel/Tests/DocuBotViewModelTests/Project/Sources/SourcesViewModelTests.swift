//
//  SourcesViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

@Suite("SourcesViewModelTests", .tags(.view))
public class SourcesViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Initialisation")
    func initialisation() {
        let documents = [
            Document.mock(id: 50),
            Document.mock(id: 65)
        ]

        // GIVEN we have a SourcesViewModel with our documents
        let testSubject = SourcesViewModel(
            sources: documents.map {
                SourceCellModel(document: $0, score: 50)
            },
            serviceContainer: self.serviceContainer
        )

        // THEN our sources reflect that
        #expect(
            testSubject.sources == documents.map {
                SourceCellModel(document: $0, score: 50)
            }
        )
    }

    @Test("Identifier")
    func id() {
        let documents = [
            Document.mock(id: 50),
            Document.mock(id: 65)
        ]

        // GIVEN we have a SourcesViewModel with our documents
        let testSubject = SourcesViewModel(
            sources: documents.map {
                SourceCellModel(document: $0, score: 50)
            },
            serviceContainer: self.serviceContainer
        )

        // THEN our ID is set correctly
        #expect(testSubject.id == 115)
    }

}
