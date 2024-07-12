//
//  PreferenceStoreService.swift
//  
//
//  Created by William Lumley on 10/7/2023.
//

import Foundation

public protocol PreferenceStoreService: Service {
    var finishedOnboarding: Bool { get set }
}
