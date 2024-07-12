//
//  MockFlagService.swift
//
//
//  Created by William Lumley on 10/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

public class MockFlagService: FlagService {

    // MARK: - Service

    public static var key: ServiceKey {
        .flag
    }

    // MARK: - Properties

    public var source: FlagValueSource
    public var appFlags: FlagPole<AppFlags>

    // MARK: - Lifecycle

    init() {
        self.source = UserDefaults.standard
        self.appFlags = FlagPole(hoist: AppFlags.self, sources: [
            self.source
        ])
    }

}
