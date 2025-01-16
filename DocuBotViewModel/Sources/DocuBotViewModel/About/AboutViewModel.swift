//
//  AboutViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 11/11/2024.
//

// Having to import AppKit makes me very sad, but necessary to open the URL
import AppKit
import DocuBotModel
import DocuBotToolbox

public class AboutViewModel: DocuBotViewModel, @unchecked Sendable {

    public let acknowledgements = Acknowledgement.all

}

// MARK: - Public

public extension AboutViewModel {

    var title: String {
        L10n.About.title
    }

    var subtitle: String {
        L10n.About.subtitle(Device.versionNumber, Device.buildNumber)
    }

    var licenceButton: MenuButtonViewModel {
        .init(text: L10n.About.licence) {
            guard let url = URL(string: Secrets.AppInfo.licenceURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    var privacyPolicyButton: MenuButtonViewModel {
        .init(text: L10n.About.privacyPolicy) {
            guard let url = URL(string: Secrets.AppInfo.privacyPolicyURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    var acknowledgementsTitle: String {
        L10n.About.ThirdPartyLibraries.title
    }

    var acknowledgementsSubtitle: String {
        L10n.About.ThirdPartyLibraries.subtitles
    }

    var acknowledgementsMarkdown: String {
        var markdown = ""
        for acknowledgement in acknowledgements {
            markdown += """
            ### \(acknowledgement.libraryName)

            **Author**: \(acknowledgement.author)\n
            **Description**: \(acknowledgement.description)\n
            **License**: \(acknowledgement.license)\n
            **Link**: [\(acknowledgement.link.absoluteString)](\(acknowledgement.link.absoluteString))\n

            ---

            """
        }

        return markdown
    }

}

// MARK: - Mock

public extension AboutViewModel {

    static var mock: AboutViewModel {
        AboutViewModel(serviceContainer: .mock)
    }

}
