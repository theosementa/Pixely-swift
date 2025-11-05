//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import MCEmojiPicker
import DesignSystem

public struct AddAlbumScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    // MARK: Init
    public init(albumId: UUID? = nil) {
        self._viewModel = State(wrappedValue: .init(albumId: albumId))
    }
    
    // MARK: - View
    public var body: some View {
        VStack(spacing: Spacing.large) {
            TextField("Album name", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.isEmojiPickerPresented.toggle()
            } label: {
                Text(viewModel.emoji)
            }
            .emojiPicker(
                isPresented: $viewModel.isEmojiPickerPresented,
                selectedEmoji: $viewModel.emoji
            )
            
            ColorPicker("Selected Color", selection: $viewModel.color)
            
            Spacer()
            
            Button {
                viewModel.createAlbum()
            } label: {
                Text("Create")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.blue, in: .rect(cornerRadius: CornerRadius.large, style: .continuous))
            }
            .padding()
        }
        .padding(Spacing.large)
    }
}

// MARK: - Preview
#Preview {
    AddAlbumScreen()
}
