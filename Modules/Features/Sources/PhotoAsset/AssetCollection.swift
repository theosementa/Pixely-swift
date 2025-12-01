//
//  AssetCollection.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos

public struct AssetCollection: RandomAccessCollection {
    public let fetchResult: PHFetchResult<PHAsset>
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { fetchResult.count }
    
    public init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }
    
    public subscript(position: Int) -> PHAsset {
        fetchResult.object(at: position)
    }
    
    public var asArray: [PHAsset] {
        var assets: [PHAsset] = []
        assets.reserveCapacity(fetchResult.count)
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        return assets
    }
}

// MARK: - PHAsset Extensions
extension PHAsset {
    public static func fetch(withLocalIdentifier identifier: String) -> PHAsset? {
        let options = PHFetchOptions()
        options.fetchLimit = 1
        return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: options).firstObject
    }
}

extension PHAsset: @retroactive Identifiable {
    public var id: String {
        localIdentifier
    }
}
