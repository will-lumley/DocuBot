//
//  SecretsTests.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 13/11/2024.
//

@testable import DocuBotToolbox
import Testing

struct SecretsTests {

    @Test("Bundle ID Values")
    func bundleIDValues() {
        typealias BundleIDs = Secrets.BundleIDs

        #expect(BundleIDs.docubot == "com.williamlumley.docubot")
        #expect(BundleIDs.settings == "com.williamlumley.docubot.settings")
        #expect(BundleIDs.appGroup == "4ELTP9RFTJ.group.com.williamlumley.docubot")
    }

    @Test("App Info Values")
    func appInfoValues() {
        typealias AppInfo = Secrets.AppInfo

        #expect(AppInfo.sourceCodeURL == "https://github.com/will-lumley/DocuBot")
        #expect(AppInfo.developerEmail == "will@lumley.io")
        #expect(AppInfo.licenceURL == "https://github.com/will-lumley/DocuBot?tab=GPL-3.0-1-ov-file")
        #expect(AppInfo.privacyPolicyURL == "https://github.com/will-lumley/DocuBot/blob/main/PrivacyPolicy.pdf")
    }

    @Test("Model Download Values")
    func modelDownloadValues() {
        typealias ModelDownloads = Secrets.ModelDownloads

        // swiftlint:disable:next line_length
        #expect(ModelDownloads.defaultModel == "https://huggingface.co/QuantFactory/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct.Q3_K_M.gguf")
    }

}
