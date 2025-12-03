//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 03/12/2025.
//

import Foundation
import Models
import Photos
import Dependencies

public final class MultiSelectionManager {
    
    @MainActor
    public static func applyAlbumToSeveralAssets(album: AlbumModel, assets: [PHAsset]) async {
        @Dependency(\.assetDetailedStore) var assetDetailedStore
        
        for asset in assets {
            let assetEntity = assetDetailedStore.fetchOneEntity(phAssetId: asset.id)
            
            if let assetEntity {
                assetDetailedStore.updateAlbum(assetEntity, newAlbumId: album.id)
            } else {
                let detailedAsset = await PHAssetHelper.detailed(for: asset)
                if let body = detailedAsset.toBody(album: album) {
                    assetDetailedStore.create(body)
                }
            }
        }
    }
    
}
