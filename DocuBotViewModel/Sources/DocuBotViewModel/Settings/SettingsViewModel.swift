//
//  SettingsViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 11/11/2024.
//

import Combine
import DocuBotService
import SFSafeSymbols

/// A view model for managing and displaying user settings within the DocuBot application.
public class SettingsViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    /// Represents the different types of help information available in the settings.
    public enum HelpType: CaseIterable, Sendable {
        /// Help information for the "Number of Example Questions" setting.
        case numberOfExampleQuestions
        /// Help information for the "Display Similarity Scoring" setting.
        case displaySimilarityScoring
        /// Help information for the "Document Prefix Count" setting.
        case documentPrefixCount
        /// Help information for the "Similarity Floor Score" setting.
        case similarityFloorScore
    }

    // MARK: - Properties

    /// The current help configuration, used to display help information to the user.
    @Published public var helpConfiguration: HelpConfiguration?

    /// The number of example questions setting.
    @Published public var numberOfExampleQuestions: Int

    /// Whether to display similarity scoring.
    @Published public var displaySimilarityScoring: Bool

    /// The document prefix count setting.
    @Published public var documentPrefixCount: Int

    /// The similarity floor score setting.
    @Published public var similarityFloorScore: Double

    // MARK: - Lifecycle

    /// Initializes a new `SettingsViewModel`.
    ///
    /// - Parameter serviceContainer: The `ServiceContainer` providing access to shared services.
    override public init(serviceContainer: ServiceContainer) {
        let preferences = serviceContainer.preferenceStoreService

        self.numberOfExampleQuestions = preferences.numberOfExampleQuestions
        self.displaySimilarityScoring = preferences.displaySimilarityScoring
        self.documentPrefixCount = preferences.documentPrefixCount
        self.similarityFloorScore = preferences.similarityFloorScore

        super.init(serviceContainer: serviceContainer)
    }

    /// Configures bindings for the settings properties to update the `PreferenceStoreService`.
    override public func configureBindings() {
        super.configureBindings()

        self.$numberOfExampleQuestions
            .sink { [unowned self] in
                var preferences = serviceContainer.preferenceStoreService
                preferences.numberOfExampleQuestions = $0
            }
            .store(in: &cancellables)

        self.$displaySimilarityScoring
            .sink { [unowned self] in
                var preferences = serviceContainer.preferenceStoreService
                preferences.displaySimilarityScoring = $0
            }
            .store(in: &cancellables)

        self.$documentPrefixCount
            .sink { [unowned self] in
                var preferences = serviceContainer.preferenceStoreService
                preferences.documentPrefixCount = $0
            }
            .store(in: &cancellables)

        self.$similarityFloorScore
            .sink { [unowned self] in
                var preferences = serviceContainer.preferenceStoreService
                preferences.similarityFloorScore = $0
            }
            .store(in: &cancellables)
    }

}

// MARK: - Public

public extension SettingsViewModel {

    // MARK: General Section

    /// The title for the general settings section.
    var generalSectionTitle: String {
        L10n.Settings.Section.General.title
    }

    /// The icon for the general settings section.
    var generalSectionIcon: SFSymbol {
        .gear
    }

    /// The title for the "Number of Example Questions" setting.
    var numberOfExampleQuestionsTitle: String {
        L10n.Settings.NumberOfQuestions.title
    }

    /// The title for the "Display Similarity Scoring" setting.
    var displaySimilarityScoringTitle: String {
        L10n.Settings.DisplaySimilarityScore.title
    }

    /// The title for the "Document Prefix Count" setting.
    var documentPrefixCountTitle: String {
        L10n.Settings.DocumentPrefixCount.title
    }

    /// The title for the "Similarity Floor Score" setting.
    var similarityFloorScoreTitle: String {
        L10n.Settings.SimilarityFloorScore.title
    }

    // MARK: Embedding Section

    /// The title for the embedding settings section.
    var embeddingSectionTitle: String {
        L10n.Settings.Section.Embedding.title
    }

    /// The icon for the embedding settings section.
    var embeddingSectionIcon: SFSymbol {
        .docViewfinder
    }

    /// The title for the document embedding settings section.
    var documentEmbeddingSectionTitle: String {
        L10n.Settings.Section.Embedding.title
    }

    // MARK: Other

    /// Handles selection of a help button for a specific `HelpType`.
    ///
    /// - Parameter type: The type of help information to display.
    func helpButtonSelected(with type: HelpType) {
        self.helpConfiguration = .init(type: type) {
            self.helpConfiguration = nil
        }
    }

}
