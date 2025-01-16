//
//  DocuBotViewModelTestCase.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 29/11/2024.
//

import AppKit
import DocuBotModel
import DocuBotService
import Testing

open class DocuBotViewModelTestCase: @unchecked Sendable {

    // MARK: - Types

    struct SharedItem {
        let recipients: [String]?
        let items: [Any]
    }

    // MARK: - Properties

    /// If a URL was attempted to open via `NSWorkspace.open(_:)`, the URL in question
    /// will be stored here.
    var openedURL: URL?

    /// If a file was attempted to be opened in Finder via
    /// `NSWorkspace.activateFileViewing(_:)`, the URL in question
    /// will be stored here.
    var viewedFiles: [URL]?

    /// If content was attempted to be shared via
    /// `NSSharingService.perform(withItems:)`, the recipients
    /// and items of the action will be stored here.
    var sharedItem: SharedItem?

    /// Our ServiceContainer created with testing equivalents
    public let serviceContainer = ServiceContainer(isTesting: true)

    var persistenceService: PersistenceService {
        serviceContainer.persistenceStorage
    }

}

// MARK: - Public

public extension DocuBotViewModelTestCase {

    /// This will fetch a very intentionally small model that is garbage, but does the
    /// job for testing purposes.
    ///
    /// - returns: The file path for a test model
    ///
    static var testModelPath: String {
        get throws {
            try #require(
                Bundle.module.path(
                    forResource: "distilgpt2Q4_0",
                    ofType: "gguf"
                )
            )
        }
    }

    @discardableResult
    func persistTestModel() async -> LLMModel {
        do {
            let llmModel = LLMModel.mock(
                path: try Self.testModelPath
            )
            let inserted = try await persistenceService
                .insert(model: llmModel)
            return inserted
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func swizzleWorkspaceOpen() {
        NSWorkspace.onOpenHandler = { url in
            self.openedURL = url
        }
        NSWorkspace.swizzleOpen()
    }

    func swizzleWorkspaceFileViewing() {
        NSWorkspace.onFileViewingHandler = { urls in
            self.viewedFiles = urls
        }
        NSWorkspace.swizzleFileViewing()
    }

    func swizzleSharingServicePerform() {
        NSSharingService.onPerformHandler = { item in
            self.sharedItem = item
        }
        NSSharingService.swizzlePerform()
    }

}

// MARK: - NSSharingService

private extension NSSharingService {

    typealias SharedItem = DocuBotViewModelTestCase.SharedItem
    typealias OnPerform = (SharedItem) -> Void

    nonisolated(unsafe) static var onPerformHandler: OnPerform?
    nonisolated(unsafe) private static var performIsSwizzled = false

    static func swizzlePerform() {
        guard performIsSwizzled == false else {
            return
        }

        let originalSelector = #selector(NSSharingService.perform(withItems:))
        let swizzledSelector = #selector(NSSharingService.mockPerform(withItems:))

        guard
            let originalMethod = class_getInstanceMethod(
                NSSharingService.self, originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                NSSharingService.self, swizzledSelector
            )
        else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc
    private func mockPerform(withItems items: [Any]) {
        // Call the handler if it's set
        let sharedItem = SharedItem(recipients: self.recipients, items: items)
        NSSharingService.onPerformHandler?(sharedItem)
    }

}

// MARK: - NSWorkspace

private extension NSWorkspace {

    typealias OnOpen = (URL) -> Void
    typealias OnFileViewing = ([URL]) -> Void

    nonisolated(unsafe) static var onOpenHandler: OnOpen?
    nonisolated(unsafe) static var onFileViewingHandler: OnFileViewing?

    nonisolated(unsafe) private static var openIsSwizzled = false
    nonisolated(unsafe) private static var fileViewingIsSwizzled = false

    static func swizzleOpen() {
        guard openIsSwizzled == false else {
            return
        }
        openIsSwizzled = true

        let originalSelector = #selector(NSWorkspace.open(_:))
        let swizzledSelector = #selector(NSWorkspace.mockOpen(_:))

        guard
            let originalMethod = class_getInstanceMethod(
                NSWorkspace.self, originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                NSWorkspace.self, swizzledSelector
            )
        else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func unswizzleOpen() {
        guard openIsSwizzled else {
            return
        }
        openIsSwizzled = false

        let originalSelector = #selector(NSWorkspace.open(_:))
        let swizzledSelector = #selector(NSWorkspace.mockOpen(_:))

        guard
            let originalMethod = class_getInstanceMethod(
                NSWorkspace.self, originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                NSWorkspace.self, swizzledSelector
            )
        else {
            return
        }

        method_exchangeImplementations(swizzledMethod, originalMethod)
    }

    @objc
    private func mockOpen(_ url: URL) -> Bool {
        // Call the handler if it's set
        NSWorkspace.onOpenHandler?(url)
        return true
    }

    static func swizzleFileViewing() {
        guard fileViewingIsSwizzled == false else {
            return
        }
        fileViewingIsSwizzled = true

        let originalSelector = #selector(NSWorkspace.activateFileViewerSelecting(_:))
        let swizzledSelector = #selector(NSWorkspace.mockFileViewing(_:))

        guard
            let originalMethod = class_getInstanceMethod(
                NSWorkspace.self, originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                NSWorkspace.self, swizzledSelector
            )
        else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func unswizzleFileViewing() {
        guard openIsSwizzled else {
            return
        }
        openIsSwizzled = false

        let originalSelector = #selector(NSWorkspace.activateFileViewerSelecting(_:))
        let swizzledSelector = #selector(NSWorkspace.mockFileViewing(_:))

        guard
            let originalMethod = class_getInstanceMethod(
                NSWorkspace.self, originalSelector
            ),
            let swizzledMethod = class_getInstanceMethod(
                NSWorkspace.self, swizzledSelector
            )
        else {
            return
        }

        method_exchangeImplementations(swizzledMethod, originalMethod)
    }

    @objc
    private func mockFileViewing(_ urls: [URL]) {
        // Call the handler if it's set
        NSWorkspace.onFileViewingHandler?(urls)
    }

}
