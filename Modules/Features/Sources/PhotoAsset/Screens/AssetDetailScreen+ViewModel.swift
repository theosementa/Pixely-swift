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
import SwiftUI

extension AssetDetailScreen {
    
    @Observable @MainActor
    final class ViewModel {
        
        var asset: PHAsset
        
        var albumSelectedId: UUID = AlbumModel.noAlbum.id
        
        var detailedAsset: PHAssetDetailedModel?
        var assetEntity: AssetDetailedEntity?
        
        @ObservationIgnored
        @Dependency(\.albumStore) private var albumStore
        
        @ObservationIgnored
        @Dependency(\.assetDetailedStore) private var assetDetailedStore
        
        @ObservationIgnored
        @Dependency(\.assetManager) private var assetManager
        
        init(asset: PHAsset) {
            self.asset = asset
        }
        
    }
    
}

// MARK: - Computed variables
extension AssetDetailScreen.ViewModel {
    
    var parentAlbumsSelectable: [AlbumModel] {
        var parentsAlbums = albumStore.parentAlbums
            .sorted { $0.name < $1.name }
        parentsAlbums.insert(.noAlbum, at: 0)
        return parentsAlbums
    }
    
    var subAlbumsSelectable: [SubAlbumModel] {
        return albumStore.subAlbums
            .sorted { $0.name < $1.name }
    }
    
    var albumSelected: AlbumModel? {
        return albumStore.fetchOne(id: albumSelectedId)
    }
}

// MARK: - Public functions
extension AssetDetailScreen.ViewModel {
    
    func deleteAsset(dismiss: DismissAction) {
        Task {
            await assetManager.deleteAsset(asset)
            dismiss()
        }
    }
    
    func setIsFavorite() {
        Task {
            await assetManager.setIsFavorite(for: asset, !asset.isFavorite)
        }
    }
    
    func onSelectNewAlbum(_ newAlbumId: UUID) {
        if let assetEntity {
            assetDetailedStore.updateAlbum(assetEntity, newAlbumId: albumSelectedId)
        } else {
            if let detailedAsset, let albumSelected, let body = detailedAsset.toBody(album: albumSelected) {
                assetDetailedStore.create(body)
            }
        }
    }
    
    func loadEntity() {
        let assetEntity = assetDetailedStore.fetchOneEntity(phAssetId: asset.id)
        self.assetEntity = assetEntity
        if let assetEntity, let album = assetEntity.album {
            self.albumSelectedId = album.id
            self.detailedAsset = assetEntity.toModel()
        }
    }
    
}
