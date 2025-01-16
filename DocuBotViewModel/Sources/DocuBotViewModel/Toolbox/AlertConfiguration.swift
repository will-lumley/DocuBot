//
//  AlertConfiguration.swift
//  DocuBotViewModel
//
//  Created by William Lumley on 12/10/2024.
//

public struct AlertConfiguration {

    public let title: String
    public let message: String

}

extension AlertConfiguration: Identifiable {

    public var id: String {
        self.title + self.message
    }

}
