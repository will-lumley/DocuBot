//
//  ProjectQuestionViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import DocuBotModel
@testable import DocuBotViewModel
import Testing

struct ProjectQuestionViewModelTests {

    @Test("Initialisation")
    func initialisation() {
        let testSubject = ProjectQuestionViewModel(content: "content") { _ in }
        #expect(testSubject.content == "content")
    }

    @Test("Identifier")
    func identifier() {
        let testSubject = ProjectQuestionViewModel(content: "content") { _ in }
        #expect(testSubject.id == "content")
    }

    @Test("On Select")
    func onSelect() {
        var selectedQuestion: String?

        // GIVEN we have a ProjectQuestionViewModel
        let testSubject = ProjectQuestionViewModel(content: "content") { content in
            selectedQuestion = content
        }

        // WHEN we are selected
        testSubject.select()

        // THEN the question is selected
        #expect(selectedQuestion == "content")
    }

}
