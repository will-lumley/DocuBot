//
//  DocuBotViewModel.swift
//
//
//  Created by William Lumley on 22/7/2024.
//

import Combine
import DocuBotService
import Foundation

/// A base class for view models in the DocuBot application, providing access to shared
/// services and lifecycle management.
public class DocuBotViewModel: ObservableObject {

    // MARK: - Services

    /// A container for accessing various services used by the view model.
    public private(set) var serviceContainer: ServiceContainer

    /// The flag service, used for managing feature flags.
    var flagService: FlagService {
        serviceContainer.flagService
    }

    /// The GPT service, used for AI-related tasks.
    var gptService: GPTService {
        serviceContainer.gptService
    }

    /// The logging service, used for capturing logs.
    var logService: LogService {
        serviceContainer.logService
    }

    /// The persistence service, used for data storage and retrieval.
    var persistenceService: PersistenceService {
        serviceContainer.persistenceStorage
    }

    /// The preference store service, used for managing user preferences.
    var preferenceStoreService: PreferenceStoreService {
        serviceContainer.preferenceStoreService
    }

    // MARK: - Properties

    /// Indicates whether the view model needs to configure bindings.
    public private(set) var needsBinding = true

    /// A set of cancellable subscriptions for Combine publishers.
    open var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    /// Initializes a new `DocuBotViewModel` with a given service container.
    ///
    /// - Parameter serviceContainer: The `ServiceContainer` providing shared services.
    public init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer
        self.configureBindingsIfNeeded()
    }

    /// Configures bindings for the view model if they are needed.
    public final func configureBindingsIfNeeded() {
        if needsBinding {
            configureBindings()
        }
    }

    /// Configures bindings for the view model. This method is intended to be overridden by subclasses.
    ///
    /// - Warning: Subclasses must not call `configureBindings()` directly. Instead, call `configureBindingsIfNeeded()`.
    open func configureBindings() {
        assert(needsBinding, "Attempting to reconfigure bindings. Don't call configureBindings() directly.")
        needsBinding = false
    }

}
