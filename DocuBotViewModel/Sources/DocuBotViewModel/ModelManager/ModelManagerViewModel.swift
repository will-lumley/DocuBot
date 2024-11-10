//
//  ModelManagerViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 29/10/2024.
//

// Having to import AppKit makes me very sad, but necessary to open the URL
import AppKit
import Combine
import DocuBotModel
import DocuBotToolbox
import Foundation
import UniformTypeIdentifiers

public class ModelManagerViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    public enum ModelError: LocalizedError {
        case noDirectory
        case failedToDelete
    }

    public enum ModelDownloadError: LocalizedError {
        case noAppSupportDirectory
        case missingDownloadFile
        case failedToCreateSubdirectory
        case failedToMoveToAppSupport
        case failedToGetFileSize
    }

    public enum ListViewState {
        case none
        case noModels(EmptyListConfiguration)
        case models([ModelCellModel])
        case downloading(Progress)
    }

    public typealias Progress = DocuBotToolbox.Progress

    public typealias OnDelete = () -> Void

    // MARK: - Properties

    /// The state that our List will represent
    @Published public var listState: ListViewState = .none

    /// The model that the user has selected from a list
    @Published public var selectedModel: ModelCellModel?

    /// This is used to create or close an `Alert`
    @Published public var alertConfiguration: AlertConfiguration?

    /// The download task progress of our default model
    private var downloadProgress: CurrentValueSubject<Progress?, Never> = .init(nil)

    /// This closure will be called if a user confirms they want to delete a project
    private var deleteModelAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteModelConfirmationDialogPresented = false

    // MARK: - Lifecycle

    override public func configureBindings() {
        super.configureBindings()

        let modelsPublisher = persistenceService.getModels()
            .map { $0.map(ModelCellModel.init) }
            .replaceError(with: [])

        let progressPublisher = self.downloadProgress.eraseToAnyPublisher()

        Publishers.CombineLatest(modelsPublisher, progressPublisher)
            .map { [unowned self] models, progress in
                // We're downloading something currently
                if let progress = progress {
                    return .downloading(progress)
                }

                // If we have no models, show an EmptyList
                if models.count <= 0 {
                    return .noModels(
                        self.emptyListConfiguration
                    )
                }

                // We do have models
                else {
                    return .models(models)
                }
            }
            .assign(to: &$listState)
    }

}

// MARK: - Public

public extension ModelManagerViewModel {

    var deleteModelConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.ModelManager.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.ModelManager.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        self.deleteModelAction?()
                    }
                ),
                .init(
                    title: L10n.ModelManager.Delete.Confirmation.cancelButton,
                    role: .cancel,
                    action: { }
                )
            ]
        )
    }
    var downloadMoreButtonTitle: String {
        L10n.ModelManager.DownloadMoreButton.title
    }

    var windowTitle: String {
        L10n.ModelManager.windowTitle
    }

    func directorySelected(_ directory: URL?) {
        do {
            guard let directory else {
                throw ModelError.noDirectory
            }
            self.importModel(from: directory)
        } catch {
            self.alertConfiguration = .init(
                title: L10n.Error.ModelManager.ModelError.title,
                message: error.description
            )
        }
    }

    func minusButtonSelected() {
        guard let selectedModel = self.selectedModel else {
            return
        }

        self.promptDeletion(of: selectedModel.model)
    }

    func downloadMoreButtonSelected() {
        let urlStr = "https://huggingface.co/models?search=GGUF"
        guard let url = URL(string: urlStr) else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    func progressTitle(for progress: Progress) -> String {
        let percentage = String(format: "%.2f", progress.percentage)
        return L10n.ModelManager.DownloadProgress.title(percentage)
    }

    func progressSubtitle(for progress: Progress) -> String {
        return L10n.ModelManager.DownloadProgress.subtitle(
            Self.formatBytesToGB(progress.value),
            Self.formatBytesToGB(progress.total)
        )
    }

    static func formatBytesToGB(_ bytes: Double) -> String {
        let gbValue = bytes / (1024 * 1024 * 1024)
        return String(format: "%.2f", gbValue)
    }

}

// MARK: - Private

private extension ModelManagerViewModel {

    var defaultDownloadURL: URL {
        let downloadStr = Secrets.ModelDownloads.defaultModel
        guard let downloadURL = URL(string: downloadStr) else {
            fatalError()
        }

        return downloadURL
    }

    var emptyListConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.ModelManager.EmptyList.title,
            subtitle: L10n.ModelManager.EmptyList.subtitle,
            icon: .arrowDownDoc,
            action: .init(
                title: L10n.ModelManager.EmptyList.Action.title,
                secondaryTitle: L10n.ModelManager.EmptyList.Action.secondaryTitle,
                onSelect: {
                    self.downloadDefaultModel()
                }
            )
        )
    }

    func downloadDefaultModel() {
        Task {
            do {
                let sourceURL = self.defaultDownloadURL
                let modelsDirectory = try self.getModelsDirectory()
                let fileName = sourceURL.lastPathComponent

                // Define the destination URL for your file
                // within the Models subdirectory.
                let destinationURL = modelsDirectory.appendingPathComponent(fileName)

                let downloadTask = DownloadTask(
                    sourceURL: self.defaultDownloadURL,
                    destinationURL: destinationURL,
                    onUpdatedPublisher: self.downloadProgress
                )

                let location = try await downloadTask.download()

                // Get the metadata for this URL
                let fileSize = Int64(try location.fileSize)

                // Persist the ModelRecord to our database
                let model = Model(
                    name: fileName,
                    path: location.path(percentEncoded: false),
                    size: fileSize,
                    createdAt: .now,
                    updatedAt: .now
                )
                _ = try await persistenceService.insert(model: model)

                // Update the state to be aware of the fact that we're
                // no longer downloading anything
                await MainActor.run {
                    self.downloadProgress.send(nil)
                }

            } catch {
                self.logService.log(
                    with: .error,
                    "Error downloading Model: \(error)"
                )

                // Reset the UI
                self.listState = .noModels(self.emptyListConfiguration)

                // Communicate the error to the user
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.ModelManager.ModelDownloadError.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func importModel(from sourceURL: URL) {
        Task {
            do {
                // Get the destination directory for models
                let modelsDirectory = try self.getModelsDirectory()
                let fileName = sourceURL.lastPathComponent
                let destinationURL = modelsDirectory
                    .appendingPathComponent(fileName)

                // Copy the model file to the destination directory
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }

                try fileManager.copyItem(
                    at: sourceURL,
                    to: destinationURL
                )

                // Get the file size
                let fileSize = Int64(try destinationURL.fileSize)

                // Persist the model in the database
                let model = Model(
                    name: fileName,
                    path: destinationURL.path(percentEncoded: false),
                    size: fileSize,
                    createdAt: .now,
                    updatedAt: .now
                )
                _ = try await persistenceService.insert(model: model)
            } catch {
                // Handle errors, possibly showing an alert to the user
                logService.log(with: .error, "Failed to import model: \(error)")
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.ModelManager.ModelImportError.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func promptDeletion(of model: Model) {
        self.deleteModelConfirmationDialogPresented = true
        self.deleteModelAction = {
            self.delete(model: model)
        }
    }

    func delete(model: Model) {
        Task {
            do {
                let success = try await persistenceService.delete(
                    model: model
                )
                if success == false {
                    throw ModelError.failedToDelete
                }
            } catch {
                await MainActor.run {
                    self.alertConfiguration = .init(
                        title: L10n.Error.ModelManager.DeleteModel.title,
                        message: error.description
                    )
                }
            }
        }
    }

    func getModelsDirectory() throws(ModelDownloadError) -> URL {
        // Firstly, we want to move our model from our temp URL
        // to our AppSupport directory
        let fileManager = FileManager.default

        guard let appSupportDirectory = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            throw ModelDownloadError.noAppSupportDirectory
        }

        // Define the "Models" subdirectory within AppSupport
        let modelsDirectory = appSupportDirectory
            .appendingPathComponent("Models", isDirectory: true)

        // Create the "Models" subdirectory if it doesn’t already exist
        do {
            try fileManager.createDirectory(
                at: modelsDirectory,
                withIntermediateDirectories: true
            )
        } catch {
            throw ModelDownloadError.failedToCreateSubdirectory
        }

        return modelsDirectory
    }

}

// MARK: - URL

private extension URL {

    typealias ModelDownloadError = ModelManagerViewModel.ModelDownloadError

    var fileSize: Int {
        get throws(ModelDownloadError) {
            do {
                let resources = try self
                    .resourceValues(forKeys: [.fileSizeKey])

                guard let fileSize = resources.fileSize else {
                    throw ModelDownloadError.failedToGetFileSize
                }
                return fileSize
            } catch {
                throw ModelDownloadError.failedToGetFileSize
            }
        }
    }

}

// MARK: - ModelError

public extension ModelManagerViewModel.ModelError {

    var errorDescription: String? {
        switch self {
        case .noDirectory:
            return L10n.Error.ModelManager.ModelError.noDirectory
        case .failedToDelete:
            return L10n.Error.ModelManager.ModelError.failedToDelete
        }
    }

}

// MARK: - ModelDownloadError

public extension ModelManagerViewModel.ModelDownloadError {

    internal typealias Strings = L10n.Error.ModelManager.ModelDownloadError

    var errorDescription: String? {
        switch self {
        case .missingDownloadFile:
            return Strings.missingDownloadFile
        case .noAppSupportDirectory:
            return Strings.noAppSupportDirectory
        case .failedToCreateSubdirectory:
            return Strings.failedToCreateSubdirectory
        case .failedToMoveToAppSupport:
            return Strings.failedToMoveToAppSupport
        case .failedToGetFileSize:
            return Strings.failedToGetFileSize
        }
    }

}

// MARK: - UTType

public extension UTType {

    static var gguf: UTType {
        guard let type = UTType(filenameExtension: "gguf") else {
            fatalError()
        }
        return type
    }

}
