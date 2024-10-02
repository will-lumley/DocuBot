//
//  File.swift
//  
//
//  Created by William Lumley on 22/7/2024.
//

import Combine
import Foundation
import DocuBotService

public class DocuBotViewModel: ObservableObject {

    // MARK: - Services

    public private(set) var serviceContainer: ServiceContainer

    var flagService: FlagService {
        serviceContainer.flagService
    }

    var gptService: GPTService {
        serviceContainer.gptService
    }

    var logService: LogService {
        serviceContainer.logService
    }

    var persistenceService: PersistenceService {
        serviceContainer.persistenceStorage
    }

    var preferenceStoreService: PreferenceStoreService {
        serviceContainer.preferenceStoreService
    }

    // MARK: - Properties

    public private(set) var needsBinding = true

    open var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer

        self.configureBindingsIfNeeded()
    }

    public final func configureBindingsIfNeeded() {
        if needsBinding {
            configureBindings()
        }
    }

    open func configureBindings() {
        assert(needsBinding, "Attempting to reconfigure bindings. Don't call configureBindings() directly.")
        needsBinding = false
    }

}

