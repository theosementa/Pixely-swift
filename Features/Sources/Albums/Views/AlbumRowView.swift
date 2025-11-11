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
    let album: any AlbumProtocol
    
    @Dependency(\.albumStore) private var albumStore
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(album.emoji)
                .font(.system(size: 20))
                
            Text(album.name)
                .customFont(.Title.medium)
                .foregroundStyle(Color.label)
                .fullWidth(.leading)
            
//            Text(albumStore.assetCount(for: album).formatted())
        }
        .padding()
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.large,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    }
}

// MARK: - Preview
#Preview {
    AlbumRowView(album: AlbumModel.mock)
}
