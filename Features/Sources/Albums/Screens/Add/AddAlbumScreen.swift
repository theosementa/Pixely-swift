//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import MCEmojiPicker
import DesignSystem
import Models

public struct AddAlbumScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Init
    public init(parentAlbum: AlbumModel? = nil, albumId: UUID? = nil) {
        self._viewModel = State(wrappedValue: .init(parentAlbum: parentAlbum, albumId: albumId))
    }
    
    // MARK: - View
    public var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.large) {
                Button {
                    viewModel.isEmojiPickerPresented.toggle()
                } label: {
                    Text(viewModel.emoji)
                        .font(.system(size: 48))
                }
                .emojiPicker(
                    isPresented: $viewModel.isEmojiPickerPresented,
                    selectedEmoji: $viewModel.emoji
                )
                
                CustomTextFieldView(
                    text: $viewModel.name,
                    config: .init(
                        title: "Nom de l'album",
                        placeholder: "Vacances"
                    )
                )
                
                ColorPicker("Selected Color", selection: $viewModel.color)
                    .labelsHidden()
                
                Spacer()
                
                ActionButtonView(title: "Create") {
                    viewModel.createAlbum()
                }
            }
            .fullSize()
            .padding(Spacing.large)
            .background(Color.Background.bg50.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddAlbumScreen()
}
