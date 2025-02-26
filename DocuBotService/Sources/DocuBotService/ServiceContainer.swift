//
//  ServiceContainer.swift
//  
//
//  Created by William Lumley on 29/6/2023.
//

import DocuBotModel
import DocuBotToolbox
import Foundation

/// A class responsible for managing and providing access to application services.
///
/// The `ServiceContainer` acts as a registry for services and configures them based on the application context,
/// such as whether the application is running in a testing environment or in production.
public class ServiceContainer {

    // MARK: - Properties

    /// A lookup table containing all registered services.
    ///
    /// Services are keyed by `ServiceKey` to ensure type-safe access to specific services.
    private var registry = [ServiceKey: Service]()

    // MARK: - Lifecycle

    /// Initializes a new `ServiceContainer` instance.
    ///
    /// Depending on the value of the `isTesting` parameter, this initializer configures
    /// either production or test services.
    ///
    /// - Parameter isTesting: A Boolean indicating whether the service container
    /// is being initialized for testing purposes. Defaults to `false`.
    public init(isTesting: Bool = false) {
        // swiftlint:disable:next direct_print
        print("[DOCUBOT] [INFO] Creating ServiceContainer. Testing: \(isTesting)")
        if isTesting {
            self.configureTestServices()
        } else {
            self.configureServices()
        }
    }
}

// MARK: - Public

public extension ServiceContainer {

    /// A Boolean value indicating whether the app is running in the settings context.
    ///
    /// This property checks if the bundle identifier matches the one specified for the settings app.
    var isSettingsApp: Bool {
        Bundle.main.bundleIdentifier == Secrets.BundleIDs.settings
    }
}

// MARK: - Private

private extension ServiceContainer {

    /// Registers a service in the container.
    ///
    /// - Parameter service: The service to be registered.
    func register<S: Service>(service: S) {
        // swiftlint:disable:next direct_print
        print("[DOCUBOT] [INFO] Registering Service: \(service)")
        self.registry[type(of: service).key] = service
    }

    /// Configures the logging service based on application flags.
    func configureLogService() {
        switch flagService.appFlags.services.logService {
        case .empty:
            self.register(service: EmptyLogService())
        case .print:
            self.register(service: PrintLogService())
        }
    }

    /// Configures services for the production environment.
    func configureServices() {
        self.register(service: VexilFlagService())
        self.register(service: SwiftLlamaService())
        self.register(service: LocalUserDefaultsService())
        self.configureLogService()
        self.register(service: GRDBService(inMemory: false, serviceContainer: self))
    }

    /// Configures services for the testing environment.
    func configureTestServices() {
        self.register(service: MockFlagService())
        self.register(service: MockGPTService())
        self.register(service: MockPreferenceStoreService())
        self.register(service: PrintLogService())
        self.register(service: GRDBService(inMemory: true, serviceContainer: self))
    }
}

// MARK: - Services

public extension ServiceContainer {

    // swiftlint:disable force_cast

    /// The flag service used to manage application flags.
    var flagService: any FlagService {
        return self.registry[.flag] as! FlagService
    }

    /// The GPT service used for conversational AI interactions.
    var gptService: any GPTService {
        return self.registry[.gpt] as! GPTService
    }

    /// The logging service for debugging and diagnostics.
    var logService: any LogService {
        return self.registry[.log] as! LogService
    }

    /// The persistence service used for data storage and retrieval.
    var persistenceStorage: any PersistenceService {
        return self.registry[.persistenceStore] as! PersistenceService
    }

    /// The preference store service for managing user preferences.
    var preferenceStoreService: any PreferenceStoreService {
        return self.registry[.preferenceStore] as! PreferenceStoreService
    }

    // swiftlint:enable force_cast

}
