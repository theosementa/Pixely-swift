//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 07/11/2025.
//

import Foundation
import Models
import Photos

extension AssetDetailedEntity {
    
    public func toModel() -> PHAssetDetailedModel {
        return .init(
            album: album?.toModel(),
            assetId: self.assetId,
            model: self.model,
            make: self.make,
            software: self.software,
            dateTime: self.dateTime,
            latitude: self.latitude,
            longitude: self.longitude,
            focal: self.focal,
            opening: self.opening,
            fileSize: self.fileSize,
            pixelWidth: self.pixelWidth,
            pixelHeight: self.pixelHeight,
            playbackStyle: PHAsset.PlaybackStyle(rawValue: Int(self.playbackStyleRawValue ?? 0)) ?? .unsupported
        )
    }
    
}
