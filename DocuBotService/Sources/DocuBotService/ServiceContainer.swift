//
//  ServiceContainer.swift
//  
//
//  Created by William Lumley on 29/6/2023.
//

import DocuBotModel
import DocuBotToolbox
import Foundation

public class ServiceContainer {

    // MARK: - Properties

    /// The lookup table of all of our services
    private var registry = [ServiceKey: Service]()

    // MARK: - Lifecycle

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

    var isSettingsApp: Bool {
        Bundle.main.bundleIdentifier == Secrets.BundleIDs.settings
    }

    func register<S: Service>(service: S) {
        // swiftlint:disable:next direct_print
        print("[DOCUBOT] [INFO] Registering Service: \(service)")
        self.registry[type(of: service).key] = service
    }

}

// MARK: - Private

private extension ServiceContainer {

    func configureFlagService() {
        self.register(service: VexilFlagService())
    }

    func configurePersistenceService() {
        self.register(service: GRDBService(serviceContainer: self))
    }

    func configureLogService() {
        switch flagService.appFlags.services.logService {
        case .empty:
            self.register(service: EmptyLogService())
        case .print:
            self.register(service: PrintLogService())
        }
    }

    func configureServices() {
        self.configureFlagService()
        self.register(service: LlamaService())
        self.register(service: LocalUserDefaultsService())
        self.configureLogService()
        self.configurePersistenceService()
    }

    func configureTestServices() {
        self.register(service: MockFlagService())
        self.register(service: LocalUserDefaultsService())
        self.register(service: PrintLogService())
        self.register(service: GRDBService(serviceContainer: self))
    }

}

// MARK: - Services

// swiftlint:disable force_cast

public extension ServiceContainer {

    var flagService: any FlagService {
        return self.registry[.flag] as! FlagService
    }

    var gptService: any GPTService {
        return self.registry[.gpt] as! GPTService
    }

    var logService: any LogService {
        return self.registry[.log] as! LogService
    }

    var persistenceStorage: any PersistenceService {
        return self.registry[.persistenceStore] as! PersistenceService
    }

    var preferenceStoreService: any PreferenceStoreService {
        return self.registry[.preferenceStore] as! PreferenceStoreService
    }

}

// swiftlint:enable force_cast
