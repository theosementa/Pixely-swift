//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import Stores
import Dependencies
import Models
import Photos
import PhotoAsset

extension AlbumDetailScreen {
    
    @MainActor @Observable
    final class ViewModel {
        
        var albumId: UUID
        var album: AlbumModel?
        
        @ObservationIgnored
        @Dependency(\.albumStore) var albumStore
        
        @ObservationIgnored
        @Dependency(\.assetDetailedStore) var assetDetailedStore
        
        @ObservationIgnored
        @Dependency(\.assetManager) var assetManager

        init(albumId: UUID) {
            self.albumId = albumId
            if let currentAlbum = albumStore.fetchOne(id: albumId) {
                self.album = currentAlbum
            }
        }
        
    }
    
}

extension AlbumDetailScreen.ViewModel {
    
    var assets: [PHAsset] {
        let assetsDetailed = assetDetailedStore.assets.filter { $0.album?.id == albumId }
        let assetsDetailedIds = assetsDetailed.map { $0.assetId }
        return assetManager.photoAssetCollection.asArray.filter { assetsDetailedIds.contains($0.id) }
    }
    
}

extension AlbumDetailScreen.ViewModel {
    
    var navigationTitle: String {
        return (album?.emoji ?? "") + (album?.name ?? "")
    }
    
}
