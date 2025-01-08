//
//  ConfigureProjectViewModel+Format.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 5/12/2024.
//

public extension ConfigureProjectViewModel {

    /// The title for the format section in the configuration UI.
    ///
    /// - Returns: A localized string representing the title of the format section.
    var formatSectionTitle: String {
        L10n.ConfigureProject.FormatSection.title
    }

    /// The subtitle for the format section in the configuration UI.
    ///
    /// - Returns: A localized string providing additional context for the format section.
    var formatSectionSubtitle: String {
        L10n.ConfigureProject.FormatSection.subtitle
    }

    /// Updates the enabled/disabled state of a specific format configuration.
    ///
    /// - Parameters:
    ///   - formatConfiguration: The `FormatConfiguration` to be updated.
    ///   - isEnabled: A Boolean indicating whether the format is enabled.
    ///
    /// - Discussion:
    /// This method identifies the format configuration by its ID and updates its `isEnabled` property.
    func set(
        formatConfiguration: FormatConfiguration,
        isEnabled: Bool
    ) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        let oldConfiguration = self.formatConfigurations[index]

        let newConfiguration = FormatConfiguration(
            order: oldConfiguration.order,
            format: oldConfiguration.format,
            isEnabled: isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    /// Updates the `other` format configuration with a new value.
    ///
    /// - Parameters:
    ///   - formatConfiguration: The `FormatConfiguration` to be updated.
    ///   - otherStr: The new value for the `other` format.
    ///
    /// - Discussion:
    /// This method ensures the `otherStr` begins with a full stop (`.`), then updates the format configuration.
    func update(
        formatConfiguration: FormatConfiguration,
        otherStr: String
    ) {
        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        var formattedOtherStr = otherStr

        if formattedOtherStr.first != "." {
            formattedOtherStr = ".\(formattedOtherStr)"
        }

        let oldConfiguration = self.formatConfigurations[index]

        let format = Format.other(formattedOtherStr)

        let newConfiguration = FormatConfiguration(
            order: oldConfiguration.order,
            format: format,
            isEnabled: oldConfiguration.isEnabled
        )

        self.formatConfigurations[index] = newConfiguration
    }

    /// Creates a new `other` format configuration.
    ///
    /// - Returns: The newly created `FormatConfiguration`.
    ///
    /// - Discussion:
    /// This method generates a new `FormatConfiguration` with an incremented ID, `other` format, and sets it as enabled.
    @discardableResult
    func createNewFormat() -> FormatConfiguration {
        let largestID = self.formatConfigurations.max {
            $0.id < $1.id
        }?.id ?? 0

        let newValue = FormatConfiguration(
            order: largestID + 1,
            format: .other("."),
            isEnabled: true
        )

        self.formatConfigurations.append(
            newValue
        )

        return newValue
    }

    /// Removes a specific `other` format configuration.
    ///
    /// - Parameter formatConfiguration: The `FormatConfiguration` to be removed.
    ///
    /// - Discussion:
    /// This method only removes configurations of the `other` format type.
    func remove(formatConfiguration: FormatConfiguration) {
        guard formatConfiguration.format.isOther else {
            return
        }

        guard let index = formatConfigurations.firstIndex(where: { $0.id == formatConfiguration.id }) else {
            return
        }

        self.formatConfigurations.remove(at: index)
    }

}
