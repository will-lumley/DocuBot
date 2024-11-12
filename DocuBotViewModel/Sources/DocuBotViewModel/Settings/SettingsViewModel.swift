//
//  SettingsViewModel.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 11/11/2024.
//

import Combine
import DocuBotService
import SFSafeSymbols

public class SettingsViewModel: DocuBotViewModel, @unchecked Sendable {

    // MARK: - Types

    public enum HelpType {
        case numberOfExampleQuestions
        case displaySimilarityScoring
        case documentPrefixCount
        case similarityFloorScore
    }

    // MARK: - Properties

    /// This is used to display help information to our user
    @Published public var helpConfiguration: HelpConfiguration?

    @Published public var numberOfExampleQuestions: Int
    @Published public var displaySimilarityScoring: Bool
    @Published public var documentPrefixCount: Int
    @Published public var similarityFloorScore: Double

    // MARK: - Lifecycle

    override public init(serviceContainer: ServiceContainer) {
        let preferences = serviceContainer.preferenceStoreService

        self.numberOfExampleQuestions = preferences.numberOfExampleQuestions
        self.displaySimilarityScoring = preferences.displaySimilarityScoring
        self.documentPrefixCount = preferences.documentPrefixCount
        self.similarityFloorScore = preferences.similarityFloorScore

        super.init(serviceContainer: serviceContainer)
    }

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

    // MARK: General

    var generalSectionTitle: String {
        L10n.Settings.Section.General.title
    }

    var generalSectionIcon: SFSymbol {
        .gear
    }

    var numberOfExampleQuestionsTitle: String {
        L10n.Settings.NumberOfQuestions.title
    }

    var displaySimilarityScoringTitle: String {
        L10n.Settings.DisplaySimilarityScore.title
    }

    var documentPrefixCountTitle: String {
        L10n.Settings.DocumentPrefixCount.title
    }

    var similarityFloorScoreTitle: String {
        L10n.Settings.SimilarityFloorScore.title
    }

    // MARK: Embedding

    var embeddingSectionTitle: String {
        L10n.Settings.Section.Embedding.title
    }

    var embeddingSectionIcon: SFSymbol {
        .docViewfinder
    }

    var documentEmbeddingSectionTitle: String {
        L10n.Settings.Section.Embedding.title
    }

    // MARK: Other

    func helpButtonSelected(with type: HelpType) {
        self.helpConfiguration = .init(type: type) {
            self.helpConfiguration = nil
        }
    }

}

// MARK: - Mock

public extension SettingsViewModel {

    static var mock: SettingsViewModel {
        .init(serviceContainer: .mock)
    }

}
