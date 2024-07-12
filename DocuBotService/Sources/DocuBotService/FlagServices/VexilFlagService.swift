//
//  FlagService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

public class VexilFlagService: FlagService {

    // MARK: - Service

    public static var key: ServiceKey {
        .flag
    }

    // MARK: - Properties

    public let appFlags: FlagPole<AppFlags>

    public let source: FlagValueSource

    // MARK: - Lifecycle

    init() {
        guard let appGroupUserDefaults = UserDefaults(suiteName: Secrets.BundleIDs.appGroup) else {
            fatalError("Failed to get AppGroup UserDefaults.")
        }

        self.source = appGroupUserDefaults
        self.appFlags = FlagPole(hoist: AppFlags.self, sources: [
            self.source
        ])
    }

}
