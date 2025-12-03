//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 03/12/2025.
//

import SwiftUI
import DesignSystem
import Photos
import Navigation
import Dependencies
import Models
import PhotoAsset

struct MultiSelectionView: View {
    
    // MARK: Dependencies
    @Binding var currentAlbumIdSelected: UUID
    @Binding var currentAssetsSelected: [PHAsset]
    @Dependency(\.albumStore) private var albumStore
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: - View
    var body: some View {
        VStack(spacing: Spacing.standard) {
            textRowView(text: "Assets selected count :", value: currentAssetsSelected.count.formatted())
            
            Button {
                router.push(.album(.selectAlbum(albumSelectedId: $currentAlbumIdSelected)))
            } label: {
                textRowView(text: "Album selected :", value: albumSelected?.name ?? "")
            }
            
            ActionButtonView(
                title: "Validate",
                config: .init(style: .classic)
            ) {
                applyAlbumToSeveralAssets()
            }
            .padding()
        }
        .padding()
        .background(
            Color.Background.bg100,
            in: .rect(
                topLeadingRadius: CornerRadius.large,
                bottomLeadingRadius: CornerRadius.deviceRadius,
                bottomTrailingRadius: CornerRadius.deviceRadius,
                topTrailingRadius: CornerRadius.large,
                style: .continuous
            )
        )
    }
}

// MARK: - Subviews
extension MultiSelectionView {
    
    func textRowView(text: String, value: String) -> some View {
        HStack {
            Text(text)
                .customFont(.Body.medium)
                .fullWidth(.leading)
            
            Text(value)
                .customFont(.Body.large)
        }
    }
    
}

// MARK: - Utils
extension MultiSelectionView {
    
    var albumSelected: AlbumModel? {
        return albumStore.fetchOne(id: currentAlbumIdSelected)
    }
    
    func applyAlbumToSeveralAssets() {
        Task {
            if let albumSelected {
                await MultiSelectionManager.applyAlbumToSeveralAssets(
                    album: albumSelected,
                    assets: currentAssetsSelected
                )
                
                currentAssetsSelected = []
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MultiSelectionView(
        currentAlbumIdSelected: .constant(AlbumModel.noAlbum.id),
        currentAssetsSelected: .constant([])
    )
}
