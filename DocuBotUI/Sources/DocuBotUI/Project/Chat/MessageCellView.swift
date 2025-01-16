//
//  MessageCellView.swift
//
//
//  Created by William Lumley on 4/7/2024.
//

import DocuBotViewModel
import SwiftUI
import AppKit
import SFSafeSymbols

public struct MessageCellView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: MessageCellViewModel
    
    // MARK: - View
    
    public var body: some View {
        if viewModel.originIsUser {
            HStack {
                Spacer()
                messageView
            }
        } else {
            HStack {
                messageView
                Spacer()
            }
        }
    }
    
    var messageView: some View {
        Text(viewModel.messageContent)
            .font(.body)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .fill(viewModel.originIsUser ? Color.blue : Color.gray)
            )
    }

}

// MARK: - Preview

#Preview {
    WelcomeProjectCellView(viewModel: .mock)
}
