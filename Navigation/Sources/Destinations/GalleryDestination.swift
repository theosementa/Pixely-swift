//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import NavigationKit
import Photos

public enum GalleryDestination: DestinationItem {
    case gallery
    case assetDetail(asset: PHAsset)
}
