//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 01/12/2025.
//

import Foundation
import Photos
import Models
import Dependencies
import PhotoAsset

// MARK: - Stored variables
extension GalleryScreen {
    
    @Observable @MainActor
    final class ViewModel {
        
        var isSelectModeEnabled: Bool = false
        var currentAssetsSelected: [PHAsset] = []
        var currentAlbumIdSelected: UUID = AlbumModel.noAlbum.id
        
        @ObservationIgnored
        @Dependency(\.albumStore) private var albumStore
        
        @ObservationIgnored
        @Dependency(\.assetDetailedStore) private var assetDetailedStore
    }
    
}

// MARK: - Computed variables
extension GalleryScreen.ViewModel {
    
    var albumSelected: AlbumModel? {
        return albumStore.fetchOne(id: currentAlbumIdSelected)
    }
    
}

// MARK: - Public functions
extension GalleryScreen.ViewModel {
    
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
