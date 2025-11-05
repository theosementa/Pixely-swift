//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import Stores
import Dependencies
import Photos
import Models

extension AssetDetailScreen {
    
    @Observable @MainActor
    final class ViewModel {
        
        var asset: PHAsset
        
        var albumSelected: AlbumModel = .noAlbum
        
        var detailedAsset: PHAssetDetailedModel?
        var assetEntity: AssetDetailedEntity?
        
        @ObservationIgnored
        @Dependency(\.albumStore) var albumStore
        
        @ObservationIgnored
        @Dependency(\.assetDetailedStore) var assetDetailedStore
        
        init(asset: PHAsset) {
            self.asset = asset
        }
        
    }
    
}

extension AssetDetailScreen.ViewModel {
    
    func loadEntity() {
        let assetEntity = assetDetailedStore.fetchOneEntity(phAssetId: asset.id)
        self.assetEntity = assetEntity
        print("🔥 ASSET : \(assetEntity)")
        if let assetEntity, let album = assetEntity.album {
            self.albumSelected = album.toModel()
        }
    }
    
}
