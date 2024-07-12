//
//  ServiceContainer+Mock.swift
//
//
//  Created by William Lumley on 24/7/2023.
//

import Foundation

public extension ServiceContainer {

    static var mock: ServiceContainer {
        ServiceContainer(isTesting: true)
    }

}
