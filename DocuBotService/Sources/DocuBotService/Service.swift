//
//  Service.swift
//  
//
//  Created by William Lumley on 29/6/2023.
//

import Foundation

public protocol Service {

    /// The key of which this service will be stored under
    static var key: ServiceKey { get }

}
