//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 07/11/2025.
//

import Foundation
import Models

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
            focal: Int(self.focal),
            opening: self.opening,
            fileSize: Int(self.fileSize),
            pixelWidth: Int(self.pixelWidth),
            pixelHeight: Int(self.pixelHeight)
        )
    }
    
}
