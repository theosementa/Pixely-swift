//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Stores
import Dependencies

public struct AlbumDetailScreen: View {
    
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
        
    public init(albumId: UUID) {
        self._viewModel = State(wrappedValue: .init(albumId: albumId))
    }
    
    // MARK: - View
    public var body: some View {
        VStack {
            Text("Hello, World! \(viewModel.albumId)")
            
            Button {
                viewModel.albumStore.delete(id: viewModel.albumId)
                dismiss()
            } label: {
                Text("Delete")
            }

        }
    }
}

// MARK: - Preview
#Preview {
    AlbumDetailScreen(albumId: UUID())
}
