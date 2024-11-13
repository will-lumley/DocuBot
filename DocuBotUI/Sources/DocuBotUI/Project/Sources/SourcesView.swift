//
//  SourcesView.swift
//  DocuBotUI
//
//  Created by William Lumley on 24/10/2024.
//

import DocuBotViewModel
import SwiftUI

public struct SourcesView: View {

    // MARK: - Properties

    @StateObject var viewModel: SourcesViewModel

    // MARK: - View

    public var body: some View {
        VStack {
            List(viewModel.sources) { source in
                SourceCell(viewModel: source)
            }
        }
    }

}
// MARK: - Preview

#Preview {
    SourcesView(viewModel: .mock)
}
