//
//  ConfirmationDialogConfiguration.ButtonConfiguration.Role+Bridge.swift
//
//
//  Created by William Lumley on 13/8/2024.
//

import DocuBotViewModel
import SwiftUI

extension ConfirmationDialogConfiguration.ButtonConfiguration.Role {

    var buttonRole: ButtonRole {
        switch self {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }

}
