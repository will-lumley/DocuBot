//
//  FlagService.swift
//
//
//  Created by William Lumley on 1/7/2023.
//

import DocuBotToolbox
import Foundation
import Vexil

public protocol FlagService: Service {
    var source: FlagValueSource { get }
    var appFlags: FlagPole<AppFlags> { get }
}
