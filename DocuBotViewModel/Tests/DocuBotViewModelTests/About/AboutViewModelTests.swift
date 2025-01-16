//
//  About.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 28/11/2024.
//

import AppKit
import DocuBotModel
import DocuBotToolbox
@testable import DocuBotViewModel
import Testing

@Suite("AboutViewModelTests", .serialized, .tags(.view))
class AboutViewModelTests: DocuBotViewModelTestCase, @unchecked Sendable {

    @Test("Label Values")
    func labelValues() {
        // GIVEN we have an AboutViewModel
        let testSubject = AboutViewModel(serviceContainer: .mock)

        // THEN all the labels are correctly set
        #expect(testSubject.title == "DocuBot")
        #expect(testSubject.subtitle == L10n.About.subtitle(Device.versionNumber, Device.buildNumber))
        #expect(testSubject.acknowledgementsTitle == "Acknowledgements")
        #expect(testSubject.acknowledgementsSubtitle == "DocuBot would not have been possible without these libraries:")
        #expect(testSubject.acknowledgementsMarkdown == Self.acknowledgementsMarkdown)
    }

    @Test("Acknowledgements")
    func acknowledgements() {
        // GIVEN we have an AboutViewModel
        let testSubject = AboutViewModel(serviceContainer: .mock)

        // THEN we have all the acknowledgements
        #expect(testSubject.acknowledgements == Acknowledgement.all)
    }

    @Test("Open Licence")
    func openLicence() async throws {
        self.swizzleWorkspaceOpen()

        // GIVEN we have an AboutViewModel
        let testSubject = AboutViewModel(serviceContainer: .mock)

        // WHEN we attempt to open up our licence
        testSubject.licenceButton.selected()

        // THEN our LicenceURL was opened
        let str = "https://github.com/will-lumley/DocuBot?tab=GPL-3.0-1-ov-file"
        #expect(openedURL == .init(string: str))
    }

    @Test("Open Privacy Policy")
    func openPrivacyPolicy() async throws {
        self.swizzleWorkspaceOpen()

        // GIVEN we have an AboutViewModel
        let testSubject = AboutViewModel(serviceContainer: .mock)

        // WHEN we attempt to open up our licence
        testSubject.privacyPolicyButton.selected()

        // THEN our PrivacyPolicyURL was opened
        let str = "https://github.com/will-lumley/DocuBot/blob/main/PrivacyPolicy.pdf"
        #expect(openedURL == .init(string: str))
    }

}

// MARK: - Private

private extension AboutViewModelTests {

    // swiftlint:disable line_length
    static var acknowledgementsMarkdown: String {
        """
        ### Vexil

        **Author**: unsignedapps

        **Description**: A Swift Package that manages feature flags in a flexible, multi-provider way.

        **License**: MIT

        **Link**: [https://github.com/unsignedapps/Vexil](https://github.com/unsignedapps/Vexil)


        ---
        ### GRDB.swift

        **Author**: groue

        **Description**: A Swift Package that provides a high-level API for performing database operations, making it easy to integrate SQLite into Swift applications with type safety and efficiency.

        **License**: MIT

        **Link**: [https://github.com/groue/GRDB.swift.git](https://github.com/groue/GRDB.swift.git)


        ---
        ### SwiftLlama

        **Author**: Shenghai Wang

        **Description**: A Swift Package that provides a Swift-y API wrapper to llama.cpp.

        **License**: MIT

        **Link**: [https://github.com/ShenghaiWang/SwiftLlama](https://github.com/ShenghaiWang/SwiftLlama)


        ---
        ### llama.cpp

        **Author**: ggerganov

        **Description**: Inference of Meta's LLaMA model (and others) in pure C/C++.

        **License**: MIT

        **Link**: [https://github.com/ggerganov/llama.cpp.git](https://github.com/ggerganov/llama.cpp.git)


        ---
        ### SFSafeSymbols

        **Author**: SFSafeSymbols

        **Description**: A Swift package that allows SFSymbols to be accessible in a type safe, enumerated, format.

        **License**: MIT

        **Link**: [https://github.com/SFSafeSymbols/SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols)


        ---
        ### similarity-search-kit

        **Author**: Zach Nagengast

        **Description**: A Swift package enabling on-device text embeddings and semantic search functionality.

        **License**: Apache 2.0

        **Link**: [https://github.com/ZachNagengast/similarity-search-kit.git](https://github.com/ZachNagengast/similarity-search-kit.git)


        ---
        ### Swiftful Loading Indicators

        **Author**: SwiftfulThinking

        **Description**: A collection of lightweight loading animations that can be applied to any SwiftUI view with 1 line of code.

        **License**: N/A

        **Link**: [https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git](https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators.git)


        ---
        ### swift-markdown-ui

        **Author**: gonzalezreal

        **Description**: MarkdownUI is a powerful library for displaying and customizing Markdown text in SwiftUI.

        **License**: MIT

        **Link**: [https://github.com/gonzalezreal/swift-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui)


        ---
        ### SwiftGen

        **Author**: SwiftGen

        **Description**: A tool that generates Swift code for accessing app resources like images, colors, and strings in a type-safe way.

        **License**: MIT

        **Link**: [https://github.com/SwiftGen/SwiftGenPlugin](https://github.com/SwiftGen/SwiftGenPlugin)


        ---
        ### Swift Lint

        **Author**: Realm

        **Description**: A tool to enforce Swift style and conventions, loosely based on the now archived GitHub Swift Style Guide.

        **License**: MIT

        **Link**: [https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint)


        ---

        """
    }
}
