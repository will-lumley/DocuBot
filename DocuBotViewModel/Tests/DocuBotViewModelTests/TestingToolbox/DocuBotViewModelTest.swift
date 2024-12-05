//
//  CraneViewModelTestCase.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 29/11/2024.
//

import AppKit
import DocuBotModel
import DocuBotService
import Testing

open class DocuBotViewModelTestCase: @unchecked Sendable {

    // MARK: - Properties

    /// If a URL was attempted to open via `NSWorkspace.open(_:)`, the URL in question
    /// will be stored here.
    var openedURL: URL?

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
            let inserted = try await persistenceService.insert(model: llmModel)
            return inserted
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

// MARK: - NSWorkspace

extension NSWorkspace {

    typealias OnOpen = (URL) -> Void

    nonisolated(unsafe) static var onOpenHandler: OnOpen?

    nonisolated(unsafe) private static var isSwizzled = false {
        didSet {
            if isSwizzled {
                // swiftlint:disable:next direct_print
                print("[DOCUBOT] [INFO] Swizzling `NSWorkspace.open(_:)`")
            } else {
                // swiftlint:disable:next direct_print
                print("[DOCUBOT] [INFO] Unswizzling `NSWorkspace.open(_:)`")
            }
        }
    }

    static func swizzleOpen() {
        guard isSwizzled == false else {
            return
        }
        isSwizzled = true

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
        guard isSwizzled else {
            return
        }
        isSwizzled = false

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

}
