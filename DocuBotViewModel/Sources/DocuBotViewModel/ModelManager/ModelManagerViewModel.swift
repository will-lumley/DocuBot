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

/// A ViewModel for managing LLM models within the DocuBot application.
///
/// - Discussion:
/// This ViewModel handles operations such as importing, deleting, downloading, and displaying models.
/// It maintains state information and progress tracking for these operations.
public class ModelManagerViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// Errors related to model management.
    public enum ModelError: LocalizedError {

        /// No directory was provided or found.
        case noDirectory

        /// Failed to delete the model.
        case failedToDelete
    }

    /// Errors that can occur during the model download process.
    public enum ModelDownloadError: LocalizedError {

        /// No application support directory was found.
        case noAppSupportDirectory

        /// The download file is missing.
        case missingDownloadFile

        /// Failed to create the required subdirectory.
        case failedToCreateSubdirectory

        /// Failed to move the downloaded file to the application support directory.
        case failedToMoveToAppSupport

        /// Unable to retrieve the file size of the downloaded model.
        case failedToGetFileSize
    }

    /// Represents the state of the model list view.
    public enum ListViewState: Sendable, Equatable {

        /// The list view has no state.
        case none

        /// The list is empty and shows a specific configuration.
        case noModels(EmptyListConfiguration)

        /// The list contains models.
        case models([ModelCellModel])

        /// A model is being downloaded, showing progress.
        case downloading(Progress)
    }

    public typealias Progress = DocuBotToolbox.Progress

    public typealias OnDelete = () async -> Void

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
    var deleteModelAction: OnDelete?

    /// Indicative of if we want to display/hide our Delete Project confirmation dialog
    @Published public var deleteModelConfirmationPresented = false

    // MARK: - Lifecycle

    /// Configures reactive bindings for the `ModelManagerViewModel`.
    override public func configureBindings() {
        super.configureBindings()

        let modelsPublisher = persistenceService.getModels()
            .map { $0.map(ModelCellModel.init) }
            .replaceError(with: [])

        let progressPublisher = downloadProgress.eraseToAnyPublisher()

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

    /// A dialog configuration for confirming model deletion.
    var deleteModelConfirmationDialog: ConfirmationDialogConfiguration {
        .init(
            title: L10n.ModelManager.Delete.Confirmation.title,
            buttons: [
                .init(
                    title: L10n.ModelManager.Delete.Confirmation.deleteButton,
                    role: .destructive,
                    action: {
                        await self.deleteModelAction?()
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

    /// Handles the selection of a file to be imported as a model.
    ///
    /// - Parameter file: The URL of the selected file, or `nil` if no file was selected.
    ///
    /// - Throws: `ModelError.noDirectory` if no directory was provided.
    func fileSelected(_ file: URL?) async {
        do {
            guard let file else {
                throw ModelError.noDirectory
            }
            await self.importModel(from: file)
        } catch {
            self.alertConfiguration = .init(
                title: L10n.Error.ModelManager.ModelError.title,
                message: error.description
            )
        }
    }

    /// Handles the "minus" button selection, prompting the deletion of the currently selected model.
    func minusButtonSelected() {
        guard let selectedModel = self.selectedModel else {
            return
        }

        self.promptDeletion(of: selectedModel.model)
    }

    /// Opens a web page to allow users to download additional models.
    func downloadMoreButtonSelected() {
        let urlStr = "https://huggingface.co/models?search=GGUF"
        guard let url = URL(string: urlStr) else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    /// Generates a title string for a given download progress.
    ///
    /// - Parameter progress: The progress of the download.
    /// - Returns: A string representing the percentage completed.
    func progressTitle(for progress: Progress) -> String {
        let percentage = String(format: "%.2f", progress.percentage)
        return L10n.ModelManager.DownloadProgress.title(percentage)
    }

    /// Generates a subtitle string for a given download progress.
    ///
    /// - Parameter progress: The progress of the download.
    /// - Returns: A string showing the downloaded and total sizes in gigabytes.
    func progressSubtitle(for progress: Progress) -> String {
        return L10n.ModelManager.DownloadProgress.subtitle(
            Self.formatBytesToGB(progress.value),
            Self.formatBytesToGB(progress.total)
        )
    }

    /// Formats a byte value into gigabytes (GB).
    ///
    /// - Parameter bytes: The size in bytes.
    /// - Returns: A formatted string representing the size in gigabytes.
    static func formatBytesToGB(_ bytes: Double) -> String {
        let gbValue = bytes / (1024 * 1024 * 1024)
        return String(format: "%.2f", gbValue)
    }

}

// MARK: - Private

private extension ModelManagerViewModel {

    /// The default URL for downloading the language model.
    ///
    /// - Returns: A `URL` object representing the default download location.
    /// - Discussion:
    /// This property retrieves the default model download URL from the application's secrets configuration.
    /// If the URL string is invalid, the application terminates with a fatal error.
    ///
    /// - Note:
    /// Ensure that `Secrets.ModelDownloads.defaultModel` is correctly configured and contains a valid URL string.
    var defaultDownloadURL: URL {
        let downloadStr = Secrets.ModelDownloads.defaultModel
        guard let downloadURL = URL(string: downloadStr) else {
            fatalError()
        }

        return downloadURL
    }

    /// The configuration for an empty model list view.
    ///
    /// - Returns: An `EmptyListConfiguration` object used when no models are available.
    /// - Discussion:
    /// This property defines the title, subtitle, and action for the empty model list view.
    /// The action allows the user to download the default model by triggering
    /// the `downloadDefaultModel()` method.
    ///
    /// - Components:
    ///   - Title: A localized string indicating the absence of models.
    ///   - Subtitle: A localized string providing additional context.
    ///   - Icon: An arrow-down document icon representing the "download" action.
    ///   - Action: A button to download the default model.
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

    /// Downloads the default language model and persists it in the database.
    ///
    /// - Discussion:
    /// This method retrieves the default model from a predefined URL and saves it
    /// in the application's "Models" directory. It also updates the list state and
    /// alerts the user in case of errors.
    func downloadDefaultModel() {
        Task {
            do {
                let sourceURL = self.defaultDownloadURL
                let modelsDirectory = try self.getModelsDirectory()
                let fileName = sourceURL.lastPathComponent

                let downloadTask = DownloadTask(
                    sourceURL: self.defaultDownloadURL,
                    destinationURL: modelsDirectory,
                    onUpdatedPublisher: self.downloadProgress
                )

                let location = try await downloadTask.download()

                // Get the metadata for this URL
                let fileSize = Int64(try location.fileSize)

                // Persist the LLMModelRecord to our database
                let model = LLMModel(
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

    /// Imports a model file into the application's models directory.
    ///
    /// - Parameter sourceURL: The URL of the model file to be imported.
    ///
    /// - Throws: An error if the import fails, including file system or persistence issues.
    func importModel(from sourceURL: URL) async {
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
            let model = LLMModel(
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
            self.alertConfiguration = .init(
                title: L10n.Error.ModelManager.ModelImportError.title,
                message: error.description
            )
        }
    }

    /// Prompts the user to confirm deletion of a model.
    ///
    /// - Parameter model: The model to be deleted.
    func promptDeletion(of model: LLMModel) {
        self.deleteModelConfirmationPresented = true
        self.deleteModelAction = {
            await self.delete(model: model)
        }
    }

    /// Deletes a model from the database and optionally from disk.
    ///
    /// - Parameter model: The model to be deleted.
    /// - Throws: `ModelError.failedToDelete` if the deletion fails.
    func delete(model: LLMModel) async {
        do {
            let success = try await persistenceService.delete(
                model: model,
                deleteModelOnDisk: Device.isUnitTesting == false
            )
            if success == false {
                throw ModelError.failedToDelete
            }
        } catch {
            self.alertConfiguration = .init(
                title: L10n.Error.ModelManager.DeleteModel.title,
                message: error.description
            )
        }
    }

    /// Retrieves the directory for storing language models.
    ///
    /// - Returns: The URL of the models directory.
    /// - Throws: `ModelDownloadError` if the directory cannot be accessed or created.
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

        // Define the "Models" and "DocuBot" subdirectory within AppSupport
        let modelsDirectory = appSupportDirectory
            .appendingPathComponent("DocuBot", isDirectory: true)
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

    /// Retrieves the file size for the current URL.
    ///
    /// - Returns: The file size in bytes.
    /// - Throws: `ModelDownloadError.failedToGetFileSize` if the file size cannot be determined.
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

    /// Provides a localized error description for `ModelError`.
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

    /// Provides a localized error description for `ModelDownloadError`.
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
