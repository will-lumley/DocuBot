//
//  ProjectViewModelStore.swift
//  DocuBotApplication
//
//  Created by William Lumley on 16/1/2025.
//

import DocuBotModel
import DocuBotService
import DocuBotViewModel
import Foundation

/// This class provides a cache for our `ProjectViewModel`s. This is necessary so
/// that we can guarantee that throughout the lifetime of our application we only create one single
/// `ProjectViewModel` for each `Project` in our lifecycle.
///
/// - Important: This store relies on the `id` property of the `Project` model to identify
/// unique projects. If a `Project` does not have an `id`, the store will terminate execution
/// with a fatal error.
final class ProjectViewModelStore {

    // MARK: - Properties

    /// The `ProjectViewModel`s live here
    private var viewModels = [Int64: ProjectViewModel]()

    /// Our `ServiceContainer` that we'll be passing to our `ProjectViewModel`s
    private let serviceContainer: ServiceContainer

    // MARK: - Lifecycle

    init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer
    }

    // MARK: - Functions

    /// Retrieves a `ProjectViewModel` for the specified `Project`. If a `ProjectViewModel`
    /// already exists for the given `Project`, the cached instance is returned.
    /// Otherwise, a new instance is created, cached, and returned.
    ///
    /// - Parameters:
    ///   - project: The `Project` for which a `ProjectViewModel` is needed.
    ///   - serviceContainer: The `ServiceContainer` used to provide shared services to
    ///   the `ProjectViewModel`.
    /// - Returns: The `ProjectViewModel` associated with the given `Project`.
    /// - Precondition: The `Project` must have a valid `id`.
    func viewModel(
        for project: Project,
        serviceContainer: ServiceContainer
    ) -> ProjectViewModel {
        // Grab the project ID.
        // If there is not one, our Project is not in the DB
        // and we should bail.
        guard let key = project.id else {
            fatalError()
        }

        // If we have already created a ViewModel for this Project,
        // we'll just return that one.
        if let existingViewModel = viewModels[key] {
            return existingViewModel
        }

        // We have not encountered this `Project` before, so we'll create
        // a new `ProjectViewModel` for it.
        let newViewModel = ProjectViewModel(
            project: project,
            serviceContainer: serviceContainer
        )

        // Let's cache it for next time
        self.viewModels[key] = newViewModel
        return newViewModel
    }

}
