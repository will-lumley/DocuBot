//
//  DocuBotViewModelTests.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import Combine
import DocuBotService
@testable import DocuBotViewModel
import Testing

struct DocuBotViewModelTests {

    @Test("Initialisation")
    func initialisation() throws {
        // GIVEN a mock service container
        let mockServiceContainer = ServiceContainer.mock

        // WHEN we initialise the DocuBotViewModel
        let testSubject = DocuBotViewModel(serviceContainer: mockServiceContainer)

        // THEN the service container is set correctly
        #expect(testSubject.serviceContainer === mockServiceContainer)
    }

    @Test("Configure Bindings")
    func configureBindings() {
        // GIVEN a mock service container
        let mockServiceContainer = ServiceContainer.mock

        // AND a subclass of DocuBotViewModel that overrides configureBindings
        class TestableDocuBotViewModel: DocuBotViewModel {
            var bindingsConfigured = false

            override func configureBindings() {
                bindingsConfigured = true
                super.configureBindings()
            }
        }

        let testSubject = TestableDocuBotViewModel(serviceContainer: mockServiceContainer)

        // WHEN configureBindingsIfNeeded is called
        testSubject.configureBindingsIfNeeded()

        // THEN bindings are configured
        #expect(testSubject.needsBinding == false)
        #expect(testSubject.bindingsConfigured == true)
    }

    @Test("Prevent Rebinding")
    func preventRebinding() {
        // GIVEN a mock service container
        let mockServiceContainer = ServiceContainer.mock

        // AND a subclass of DocuBotViewModel that overrides configureBindings
        class TestableDocuBotViewModel: DocuBotViewModel {
            override func configureBindings() {
                super.configureBindings()
            }
        }

        let testSubject = TestableDocuBotViewModel(serviceContainer: mockServiceContainer)

        // WHEN configureBindingsIfNeeded is called twice
        testSubject.configureBindingsIfNeeded()
        let firstNeedsBinding = testSubject.needsBinding
        testSubject.configureBindingsIfNeeded()

        // THEN bindings are not reconfigured
        #expect(firstNeedsBinding == false)
        #expect(testSubject.needsBinding == false)
    }

    @Test("Lifecycle Cleanup")
    func lifecycleCleanup() {
        // GIVEN a subclass of DocuBotViewModel
        class TestableDocuBotViewModel: DocuBotViewModel {}

        let testSubject = TestableDocuBotViewModel(serviceContainer: .mock)

        // WHEN we add a cancellable
        let dummyCancellable = AnyCancellable {}
        testSubject.cancellables.insert(dummyCancellable)

        // THEN the cancellable set contains the added cancellable
        #expect(testSubject.cancellables.contains(dummyCancellable) == true)
    }

}
