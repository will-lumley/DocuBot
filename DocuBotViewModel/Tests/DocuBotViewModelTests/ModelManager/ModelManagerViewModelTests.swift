//
//  ModelManagerViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import AppKit
import DocuBotModel
import DocuBotService
@testable import DocuBotViewModel
import Foundation
import Testing

@Suite("ModelManagerViewModelTests", .serialized, .tags(.view))
class ModelManagerViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Labels")
    func labels() throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // THEN our labels are setup correctly
        #expect(testSubject.windowTitle == "Model Manager")
        #expect(testSubject.downloadMoreButtonTitle == "Find New Models")
    }

    @Test("Delete Model Confirmation Dialogue")
    func deleteModelDialogue() async throws {
        var deleteActionCalled = false

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )
        testSubject.deleteModelAction = {
            deleteActionCalled = true
        }

        // WHEN we create our Delete Confirmation
        let deleteConfirmation = testSubject.deleteModelConfirmationDialog

        // THEN it's titles and buttons are set correctly
        #expect(deleteConfirmation.title == "Are you sure you want to delete this model?")
        #expect(
            deleteConfirmation.buttons == [
                .init(title: "Delete this Model", role: .destructive, action: { }),
                .init(title: "Cancel", role: .cancel, action: { })
            ]
        )

        // WHEN we call the action
        await deleteConfirmation.buttons
            .first { $0.role == .destructive }?
            .action()

        // THEN our delete action is called
        #expect(deleteActionCalled == true)
    }

    @Test("No File Selected")
    func noFileSelected() async throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we select no directory
        await testSubject.fileSelected(nil)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to get file access",
                message: "No directory selected."
            )
        )
    }

    @Test("Invalid File Selected")
    func invalidFileSelected() async throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN an invalid URL is selected
        let testURL = URL(fileURLWithPath: "/foo/bar/foobar")
        await testSubject.fileSelected(testURL)

        // THEN we get an alert
        let alert = try await testSubject.$alertConfiguration.firstCompactValue()

        // THEN the alert has the correct values
        #expect(
            alert == .init(
                title: "Failed to import model",
                message: "The file “foobar” couldn’t be opened because there is no such file."
            )
        )
    }

    @Test("File Selected")
    func fileSelected() async throws {
        // Ensure we have no models in the DB
        var models = try await persistenceService.getModels()
        #expect(models.count == 0)

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // Let's create a directory to call our own
        let testURLDir = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DocuBot-Test")
            .appendingPathComponent("test-models")
        try FileManager.default.createDirectory(
            at: testURLDir,
            withIntermediateDirectories: true
        )

        // Write in a file and persist it in the directory
        let fileURL = testURLDir
            .appendingPathComponent("test-model.txt")
        try "HelloWorld"
            .write(to: fileURL, atomically: true, encoding: .utf8)

        // WHEN a URL is selected
        await testSubject.fileSelected(fileURL)

        // THEN we do not get an alert
        #expect(testSubject.alertConfiguration == nil)

        // THEN we have a Model in the DB
        models = try await persistenceService.getModels()
        #expect(models.count == 1)

        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let expectedPath = appSupportURL.appendingPathComponent("DocuBot/Models/test-model.txt").path

        // THEN our Model properties are correctly set
        let model = try #require(models.first)
        #expect(model.id == 1)
        #expect(model.name == "test-model.txt")
        #expect(model.path == expectedPath)
        #expect(model.size == 10)

        // THEN we make sure that there is actually a file at the path
        let dataURL = URL(fileURLWithPath: model.path)
        let data = try Data(contentsOf: dataURL)

        // THEN we can decode the data and make sure it was carried across
        let decoded = String(bytes: data, encoding: .utf8)
        #expect(decoded == "HelloWorld")
    }

    @Test("Minus Button Selected With Nothing Selected")
    func minusButtonSelectedNothingSelected() throws {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we have nothing selected
        testSubject.selectedModel = nil

        // WHEN we select the minus button
        testSubject.minusButtonSelected()

        // THEN nothing happens
        #expect(testSubject.deleteModelConfirmationPresented == false)
    }

    @Test("Minus Button Selected and then Canceled")
    func minusButtonSelectedCanceled() async throws {
        // Ensure we have a model in the DB
        let testModel = await persistTestModel()
        let modelID = try testModel.id
            .orThrow(LLMModel.ModelError.missingID)

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we have a model selected
        testSubject.selectedModel = .init(model: testModel)

        // WHEN we select the minus button
        testSubject.minusButtonSelected()

        // THEN the delete confirmation dialog is presented
        #expect(testSubject.deleteModelConfirmationPresented == true)

        // WHEN the user selects cancel on the delete model confirmation
        await testSubject.deleteModelConfirmationDialog.buttons
            .first { $0.role == .cancel }?
            .action()

        // THEN the model hasn't been deleted and is still in the DB
        let newModel = try await persistenceService.getModel(id: modelID)
        #expect(newModel == testModel)
    }

    @Test("Minus Button Selected")
    func minusButtonSelected() async throws {
        // Ensure we have a model in the DB
        let testModel = await persistTestModel()
        let modelID = try testModel.id
            .orThrow(LLMModel.ModelError.missingID)

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we have a model selected
        testSubject.selectedModel = .init(model: testModel)

        // WHEN we select the minus button
        testSubject.minusButtonSelected()

        // THEN the delete confirmation dialog is presented
        #expect(testSubject.deleteModelConfirmationPresented == true)

        // WHEN the user selects cancel on the delete model confirmation
        await testSubject.deleteModelConfirmationDialog.buttons
            .first { $0.role == .destructive }?
            .action()

        // THEN the model has been deleted
        await #expect(throws: PersistenceError.valueNotFound) {
            try await persistenceService.getModel(id: modelID)
        }
    }

    @Test("Download More Button Selected")
    func downloadMoreButtonSelected() {
        self.swizzleWorkspaceOpen()

        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // WHEN we attempt to open up more models
        testSubject.downloadMoreButtonSelected()

        // THEN the correct URL was opened
        let str = "https://huggingface.co/models?search=GGUF"
        #expect(openedURL == .init(string: str))
    }

    @Test("Progress Title")
    func progressTitle() {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // THEN our progress title is correct
        #expect(
            testSubject.progressTitle(for: .init(value: 50, total: 100)) == "Model download is 50.00% complete"
        )

        // THEN our progress title is correct
        #expect(
            testSubject.progressTitle(for: .init(value: 0.15, total: 1.0)) == "Model download is 15.00% complete"
        )
    }

    @Test("Progress Subtitle")
    func progressSubtitle() {
        // GIVEN we have a ModelManagerViewModel
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // THEN our progress title is correct
        let subtitle = testSubject.progressSubtitle(
            for: .init(value: 109951162, total: 1099511627776)
        )
        #expect(
            subtitle == "0.10GB of 1024.00GB downloaded"
        )
    }

    @Test("Bytes to GigaBytes")
    func bytesToGigabytes() {
        #expect(
            ModelManagerViewModel.formatBytesToGB(1024884898) == "0.95"
        )
        #expect(
            ModelManagerViewModel.formatBytesToGB(1073741824) == "1.00"
        )
    }

    @Test("List State - Empty and Progress")
    func emptyProgressListState() async throws {
        typealias ListViewState = ModelManagerViewModel.ListViewState

        // GIVEN we have a ModelManagerViewModel, and no Models in the DB
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // Create an iterator to get our values over time
        var iterator = testSubject.$listState.values.makeAsyncIterator()
        testSubject.configureBindingsIfNeeded()

        // THEN the ListState is .none
        #expect(await iterator.next() == ListViewState.none)

        // THEN the second ListState is .empty
        guard case .noModels(let configuration) = await iterator.next() else {
            Issue.record("ListState is of type: \(testSubject.listState)")
            return
        }

        // THEN the empty configuration matches up
        // swiftlint:disable line_length
        #expect(configuration.title == "No models imported yet")
        #expect(configuration.subtitle == "DocuBot runs AI models locally on your Mac, ensuring maximum privacy and security. Chat with a variety of AI models, each offering unique expertise based on its training data and knowledge base.\n\nImport a model from your device using the + button, or download a recommended one using the button below.")
        #expect(configuration.icon == .arrowDownDoc)
        #expect(configuration.action?.title == "Download Default Model")
        #expect(configuration.action?.secondaryTitle == "~3.74 GB")
        // swiftlint:enable line_length

        // WHEN we select the EmptyConfiguration action
        configuration.action?.onSelect()

        // THEN the default model is attempted to be downloaded
        guard case .downloading(let progress) = await iterator.next() else {
            Issue.record("ListState is of type: \(testSubject.listState)")
            return
        }
        #expect(progress.total > 0)
    }

    @Test("List State - Models")
    func modelsListState() async throws {
        typealias ListViewState = ModelManagerViewModel.ListViewState

        // Ensure we have a model in the DB
        let model = await self.persistTestModel()

        // GIVEN we have a ModelManagerViewModel, and Models in the DB
        let testSubject = ModelManagerViewModel(
            serviceContainer: serviceContainer
        )

        // Create an iterator to get our values over time
        var iterator = testSubject.$listState.values.makeAsyncIterator()
        testSubject.configureBindingsIfNeeded()

        // THEN the ListState is initially .none
        #expect(await iterator.next() == ListViewState.none)

        // THEN our ListState shows the models
        #expect(await iterator.next() == .models([.init(model: model)]))
    }

}
