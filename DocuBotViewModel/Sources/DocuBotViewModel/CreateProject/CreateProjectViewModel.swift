//
//  CreateProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import Foundation

public class CreateProjectViewModel: DocuBotViewModel {

    // MARK: - Types

    public typealias Format = ProjectSettings.DocumentationFormat

    public struct OpenWindowPackage: Hashable, Codable {
        
    }

    public struct DocumentationFormatConfiguration: Identifiable {
        public let order: Int
        public let format: Format
        public let isEnabled: Bool

        public var id: Int {
            self.order
        }
    }

    public enum LoadState {
        case idle
        case creating
        case created
    }

    // MARK: - Properties

    @Published public var loadState = LoadState.idle
    @Published public var continueButtonEnabled = false
    @Published public var directoryText: String
    public let availableLanguages = ProjectSettings.Language.allCases

    @Published public var projectDirectory: URL?
    @Published public var projectName = ""
    @Published public var formatConfigurations: [DocumentationFormatConfiguration]
    @Published public var selectedLanguage: ProjectSettings.Language

    // MARK: - Lifecycle

    public override init(serviceContainer: ServiceContainer) {
        self.directoryText = L10n.CreateProject.Configuration.Directory.select
        self.selectedLanguage = .english

        self.formatConfigurations = Format.allCases
            .enumerated()
            .map { index, format in
                .init(order: index, format: format, isEnabled: format.isOther == false)
            }

        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // If there's even one "true"/checked format, then we'll enable the Continue Button
        let formatValidation = self.$formatConfigurations
            .map { $0.map { $0.isEnabled } } // Map it into an array of `Bool`s
            .map { $0.contains(true) }       // Check if there's even one `true`

        // The directory cannot be nil
        let directoryValidation = self.$projectDirectory
            .map { $0 != nil }

        // Combine the validation publishers
        Publishers.CombineLatest(formatValidation, directoryValidation)
            .map { $0 && $1 } // All validations must be met
            .assign(to: &$continueButtonEnabled)

        // When the directory is updated
        self.$projectDirectory
            .map { directory in
                // If the directory exists, return the path
                if let directory {
                    return directory.path()
                }

                // Return the placeholder text if there's no directory
                else {
                    return L10n.CreateProject.Configuration.Directory.select
                }
            }
            .assign(to: &$directoryText)

        // When the directory is updated, update the name
        self.$projectDirectory
            .compactMap { $0 }
            .map { $0.lastPathComponent }
            .assign(to: &$projectName)
    }

}

// MARK: - Public

public extension CreateProjectViewModel {

    var windowTitle: String {
        L10n.CreateProject.windowTitle
    }

    var formTitle: String {
        L10n.CreateProject.formTitle
    }

    var projectNameTitle: String {
        L10n.CreateProject.Configuration.Name.title
    }

    var generalSectionTitle: String {
        L10n.CreateProject.Configuration.GeneralSection.title
    }

    var projectDirectoryTitle: String {
        L10n.CreateProject.Configuration.ProjectDirectory.title
    }

    var languageTitle: String {
        L10n.CreateProject.Configuration.Language.title
    }

    var formatSectionTitle: String {
        L10n.CreateProject.Configuration.FormatSection.title
    }

    var createProjectButtonTitle: String {
        L10n.CreateProject.createButton
    }

    func set(formatConfiguration: DocumentationFormatConfiguration, isEnabled: Bool) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        let oldConfiguration = self.formatConfigurations[index]

        // We only want to flip the `isEnabled`
        let newConfiguration = DocumentationFormatConfiguration(
            order: oldConfiguration.order,
            format: oldConfiguration.format,
            isEnabled: isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    func update(formatConfiguration: DocumentationFormatConfiguration, otherStr: String) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        var formattedOtherStr = otherStr

        // Is the first character NOT a full-stop? If not, add one in
        if formattedOtherStr.first != "." {
            formattedOtherStr = ".\(formattedOtherStr)"
        }

        let oldConfiguration = self.formatConfigurations[index]

        let format = Format.other(formattedOtherStr)

        // We only want to update the `format`
        let newConfiguration = DocumentationFormatConfiguration(
            order: oldConfiguration.order,
            format: format,
            isEnabled: oldConfiguration.isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    func createNewFormat() {
        self.formatConfigurations.append(
            .init(
                order: self.formatConfigurations.count + 1,
                format: .other("."),
                isEnabled: true
            )
        )
    }

    func remove(formatConfiguration: DocumentationFormatConfiguration) {
        // We only want to remove `other` formats
        guard formatConfiguration.format.isOther else {
            return
        }

        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        self.formatConfigurations.remove(at: index)
    }

    func createProjectButtonSelected() {
        guard let directory = self.projectDirectory else {
            return
        }

        let formats = self.formatConfigurations
            .map(\.format)

        // Extract all our relevant documents (each document = one string)
        let documents = self.loadDocumentationFiles(from: directory, formats: formats)
        guard let checksum = try? documents.generateChecksum() else {
            return
        }
        print("Checksum: \(checksum)")

        let project = Project(
            id: 0,
            path: directory.path(),
            name: self.projectName,
            documentationChecksum: checksum,
            createdAt: .now,
            updatedAt: .now
        )

        Task {
            do {
                try await persistenceService.insert(project: project)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

}

// MARK: - Private

private extension CreateProjectViewModel {

    func loadDocumentationFiles(from directory: URL, formats: [Format]) -> [Document] {
        var strs = [String]()
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)

        while let fileURL = enumerator?.nextObject() as? URL {
            if formats.map(\.extensionName).contains(fileURL.pathExtension) {
                if let content = try? String(contentsOf: fileURL) {
                    strs.append(content)
                }
            }
        }

        return strs.map(Document.init)
    }

}

// MARK: - Preview

public extension CreateProjectViewModel {

    static var mock: CreateProjectViewModel {
        .init(
            serviceContainer: .mock
        )
    }

}
