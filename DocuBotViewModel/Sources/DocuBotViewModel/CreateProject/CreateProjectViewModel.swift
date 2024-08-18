//
//  CreateProjectViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import DocuBotService
import Foundation

public class CreateProjectViewModel: DocuBotViewModel {

    // MARK: - Types

    public struct OpenWindowPackage: Hashable, Codable {
        public let directory: URL
    }

    // MARK: - Properties

    public let directory: URL

    // MARK: - Lifecycle

    public init(directory: URL, serviceContainer: ServiceContainer) {
        self.directory = directory
        super.init(serviceContainer: serviceContainer)
    }

}

// MARK: - Public

public extension CreateProjectViewModel {

    var windowTitle: String {
        L10n.CreateProject.windowTitle
    }

    var projectDirectoryTitle: String {
        L10n.CreateProject.Configuration.ProjectDirectory.title
    }

    var projectDirectory: String {
        self.directory.path()
    }

    var formatTitle: String {
        L10n.CreateProject.Configuration.Format.title
    }

}

// MARK: - Private

private extension CreateProjectViewModel {

    

}

// MARK: - Preview

public extension CreateProjectViewModel {

    static var mock: CreateProjectViewModel {
        .init(
            directory: URL(string: "/Users/will/Desktop/")!,
            serviceContainer: .mock
        )
    }

}
