//
//  Date+SecondsFrom1970.swift
//  DocuBotToolbox
//
//  Created by William Lumley on 20/11/2024.
//

import Foundation

public extension Date {

    var secondsFrom1970: Int {
        Int(self.timeIntervalSince1970)
    }

}
