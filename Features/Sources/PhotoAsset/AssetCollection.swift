//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos

class AssetCollection: RandomAccessCollection {
    private(set) var fetchResult: PHFetchResult<PHAsset>
    private var iteratorIndex: Int = 0
    
    var startIndex: Int { 0 }
    var endIndex: Int { fetchResult.count }
    
    init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    subscript(position: Int) -> PHAsset {
        return fetchResult.object(at: position)
    }
    
    var phAssets: [PHAsset] {
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

    func next() -> PHAsset? {
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
