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

/// The `AboutViewModel` provides data and actions for the "About" section of the application.
///
/// This view model supplies the information required for displaying app details,
/// third-party library acknowledgements, and important links such as the license and privacy policy.
public class AboutViewModel: DocuBotViewModel, @unchecked Sendable {

    /// A collection of acknowledgements for third-party libraries used in the application.
    public let acknowledgements = Acknowledgement.all

}

// MARK: - Public

public extension AboutViewModel {

    /// The title for the About screen.
    var title: String {
        L10n.About.title
    }

    /// The subtitle for the About screen, containing the app version and build number.
    ///
    /// - Returns: A localized string containing the app's version and build details.
    var subtitle: String {
        L10n.About.subtitle(Device.versionNumber, Device.buildNumber)
    }

    /// Provides the button for accessing the app's license.
    ///
    /// - Returns: A `MenuButtonViewModel` configured to open the license URL in the default browser.
    var licenceButton: MenuButtonViewModel {
        .init(text: L10n.About.licence) {
            guard let url = URL(string: Secrets.AppInfo.licenceURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    /// Provides the button for accessing the app's privacy policy.
    ///
    /// - Returns: A `MenuButtonViewModel` configured to open the privacy policy URL in
    /// the default browser.
    var privacyPolicyButton: MenuButtonViewModel {
        .init(text: L10n.About.privacyPolicy) {
            guard let url = URL(string: Secrets.AppInfo.privacyPolicyURL) else {
                return
            }
            NSWorkspace.shared.open(url)
        }
    }

    /// The title for the acknowledgements section.
    ///
    /// - Returns: A localized string for the section title.
    var acknowledgementsTitle: String {
        L10n.About.ThirdPartyLibraries.title
    }

    /// The subtitle for the acknowledgements section.
    ///
    /// - Returns: A localized string for the section subtitle.
    var acknowledgementsSubtitle: String {
        L10n.About.ThirdPartyLibraries.subtitles
    }

    /// The markdown representation of all third-party acknowledgements.
    ///
    /// - Returns: A string containing formatted markdown details for each third-party library,
    /// including name, author, description, license, and a link.
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
