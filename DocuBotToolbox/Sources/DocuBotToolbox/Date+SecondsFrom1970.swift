//
//  Date+SecondsFrom1970.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/11/2024.
//

import Foundation

/// An extension on `Date` to provide a computed property for seconds elapsed since 1970.
public extension Date {

    /// The number of whole seconds elapsed since January 1, 1970.
    ///
    /// This property converts the time interval since 1970, in seconds, to an integer value.
    ///
    /// - Returns: An `Int` representing the number of whole seconds elapsed since 1970.
    var secondsFrom1970: Int {
        Int(self.timeIntervalSince1970)
    }

}
