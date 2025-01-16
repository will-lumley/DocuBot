//
//  Project.AlertStatus+UI.swift
//  DocuBotUI
//
//  Created by William Lumley on 29/10/2024.
//

import DocuBotModel
import SFSafeSymbols
import SwiftUI

extension Project.AlertStatus {

    var icon: Image? {
        switch self {
        case .warning:
            return Image(systemSymbol: .exclamationmarkTriangle)
        case .error:
            return Image(systemSymbol: .exclamationmarkTriangleFill)
        case .none:
            return nil
        }
    }

    var color: Color {
        switch self {
        case .warning:
            return Color.yellow
        case .error:
            return Color.red
        case .none:
            return Color.primary
        }
    }

}
