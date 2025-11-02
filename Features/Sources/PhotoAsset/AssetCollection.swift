//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos

public class AssetCollection: RandomAccessCollection {
    private(set) var fetchResult: PHFetchResult<PHAsset>
    private var iteratorIndex: Int = 0
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { fetchResult.count }
    
    public init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    public subscript(position: Int) -> PHAsset {
        return fetchResult.object(at: position)
    }
    
    public var phAssets: [PHAsset] {
        var assets = [PHAsset]()
        fetchResult.enumerateObjects { (object, _, _) in
            assets.append(object)
        }
        return assets
    }
    
    static func fetchAsset(withLocalIdentifier localIdentifier: String) -> PHAsset? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "localIdentifier == %@", localIdentifier)
        fetchOptions.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        return fetchResult.firstObject
    }
}

extension AssetCollection: Sequence, IteratorProtocol {

    public func next() -> PHAsset? {
        if iteratorIndex >= count {
            return nil
        }
        
        defer {
            iteratorIndex += 1
        }
        
        return self[iteratorIndex]
    }
}

extension PHAsset: @retroactive Identifiable {
    public var id: String {
        self.localIdentifier
    }
}
