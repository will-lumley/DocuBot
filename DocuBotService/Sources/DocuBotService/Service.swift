//
//  Service.swift
//  
//
//  Created by William Lumley on 29/6/2023.
//

import Foundation

/// A protocol that defines the requirements for a service to be managed by a `ServiceContainer`.
///
/// Conforming types represent individual services that can be registered in the service container
/// and accessed via a unique key.
public protocol Service {

    /// The unique key under which the service will be registered.
    ///
    /// Each service must provide a static key that identifies it within the `ServiceContainer`.
    /// This key ensures type-safe access to the service.
    static var key: ServiceKey { get }

}
