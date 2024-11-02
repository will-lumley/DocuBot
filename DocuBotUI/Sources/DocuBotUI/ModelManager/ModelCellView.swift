//
//  ModelCellView.swift
//  DocuBotUI
//
//  Created by William Lumley on 30/10/2024.
//

import DocuBotViewModel
import SwiftUI

public struct ModelCellView: View {

    // MARK: - Properties

    let viewModel: ModelCellModel

    public static let id = "ModelView"

    // MARK: - View

    public var body: some View {
        HStack {
            VStack {
                Text(viewModel.title)
                    .font(.headline)

                Text(viewModel.subtitle)
                    .font(.footnote)
            }
            .padding(.vertical, 2)
        }
    }

}
