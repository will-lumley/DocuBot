//
//  ServiceContainerTests.swift
//  DocuBotService
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotService
import Testing

struct ServiceContainerTests {

    @Test("Registry Setup")
    func registrySetup() {
        let testSubject = ServiceContainer()

        // Ensure our FlagService has the production type
        let flagService = testSubject.flagService
        #expect(flagService is VexilFlagService)

        // Ensure our PersistenceService has the production type
        let persistenceStorage = testSubject.persistenceStorage
        #expect(persistenceStorage is GRDBService)

        // Ensure our PreferencesService has the production type
        let preferenceStoreService = testSubject.preferenceStoreService
        #expect(preferenceStoreService is LocalUserDefaultsService)

        // Ensure our LogService has the production type
        let logService = testSubject.logService
        #expect(logService is EmptyLogService)

        // Ensure our GPTService has the production type
        let gptService = testSubject.gptService
        #expect(gptService is LlamaService)
    }

    @Test("Registry Test Setup")
    func registryTestSetup() {
        let testSubject = ServiceContainer(isTesting: true)

        // Ensure our FlagService has the production type
        let flagService = testSubject.flagService
        #expect(flagService is MockFlagService)

        // Ensure our PersistenceService has the production type
        let persistenceStorage = testSubject.persistenceStorage
        #expect(persistenceStorage is GRDBService)

        // Ensure our PreferencesService has the production type
        let preferenceStoreService = testSubject.preferenceStoreService
        #expect(preferenceStoreService is MockPreferenceStoreService)

        // Ensure our LogService has the production type
        let logService = testSubject.logService
        #expect(logService is PrintLogService)

        // Ensure our GPTService has the production type
        let gptService = testSubject.gptService
        #expect(gptService is MockGPTService)
    }

    @Test("Settings App Detection")
    func settingsAppDetection() {
        let testSubject = ServiceContainer()
        #expect(testSubject.isSettingsApp == false)
    }

}
