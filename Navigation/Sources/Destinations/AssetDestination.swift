//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 11/11/2025.
//

import Foundation
import NavigationKit
import Models
import Photos

public enum AssetDestination: DestinationItem {
    case assetDetail(asset: PHAsset)
    case assetInfo(asset: PHAssetDetailedModel?)
}
