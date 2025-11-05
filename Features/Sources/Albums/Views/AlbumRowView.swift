//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import SwiftUI
import Models
import DesignSystem
import Dependencies

struct AlbumRowView: View {
    
    // MARK: Dependencies
    let album: AlbumModel
    
    @Dependency(\.albumStore) private var albumStore
    
    // MARK: - View
    var body: some View {
        HStack(spacing: Spacing.small) {
            Text(album.emoji)
                
            Text(album.name)
                .fullWidth(.leading)
            
            Text(albumStore.assetCount(for: album).formatted())
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumRowView(album: .mock)
}
