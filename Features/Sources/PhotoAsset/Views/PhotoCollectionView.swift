//
//  PhotoCollectionView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import UIKit
import Photos
import SwiftUI
import Stores
import Utilities
import Dependencies

public struct PhotoCollectionView: UIViewRepresentable {
    
    // MARK: Dependencies
    var assets: [PHAsset]
    var itemSpacing: CGFloat
    var onAssetSelected: (PHAsset) -> Void
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
        
    // MARK: Environments
    @Environment(AssetManager.self) private var assetManager
//    @Dependency(\.assetManager) private var assetManager
    
    public init(
        assets: [PHAsset],
        itemSpacing: CGFloat,
        onAssetSelected: @escaping (PHAsset) -> Void
    ) {
        self.assets = assets
        self.itemSpacing = itemSpacing
        self.onAssetSelected = onAssetSelected
        self.headerHeight = 0
        self.footerHeight = 0
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UICollectionView {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = itemSpacing * 6 // 5 images + les 2 bords
        let itemWidth = (screenWidth - totalSpacing) / 5
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.itemSize = itemSize
        layout.sectionInset = UIEdgeInsets(
            top: headerHeight + itemSpacing,
            left: itemSpacing,
            bottom: itemSpacing + footerHeight,
            right: itemSpacing
        )
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        collectionView.prefetchDataSource = context.coordinator
        collectionView.contentInsetAdjustmentBehavior = .never // Prevent automatic content inset adjustments
        collectionView.backgroundColor = UIColor(Color.Background.bg50)
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        // Update layout with current header height if needed
        if let layout = uiView.collectionViewLayout as? UICollectionViewFlowLayout {
            let currentTopInset = layout.sectionInset.top
            if currentTopInset != headerHeight + itemSpacing {
                layout.sectionInset = UIEdgeInsets(
                    top: headerHeight + itemSpacing,
                    left: itemSpacing,
                    bottom: itemSpacing + footerHeight,
                    right: itemSpacing
                )
                uiView.collectionViewLayout = layout
            }
        }
        
        if context.coordinator.assets != assets {
            context.coordinator.assets = assets
            uiView.reloadData()
        }
    }
    
    @MainActor
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, cacheManager: assetManager.cacheManager.imageManager, onAssetSelected: onAssetSelected)
    }
    
    // MARK: - Coordinator
    public class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
        private let parent: PhotoCollectionView
        private let cacheManager: PHCachingImageManager
        private let onAssetSelected: (PHAsset) -> Void
        private let imageRequestOptions: PHImageRequestOptions
        var assets: [PHAsset] = []
        
        @Dependency(\.assetDetailedStore) private var assetDetailedStore
        
        private var imageRequestIDs: [IndexPath: PHImageRequestID] = [:]
        
        init(_ parent: PhotoCollectionView, cacheManager: PHCachingImageManager, onAssetSelected: @escaping (PHAsset) -> Void) {
            self.parent = parent
            self.cacheManager = cacheManager
            self.onAssetSelected = onAssetSelected
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.resizeMode = .exact
            self.imageRequestOptions = options
            
            super.init()
        }
        
        // MARK: UICollectionViewDataSource
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return assets.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard indexPath.item < assets.count else {
                return cell
            }
            
            let asset = assets[indexPath.item]
            
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let itemSize = layout?.itemSize ?? CGSize(width: 100, height: 100)
            
            if let requestID = imageRequestIDs[indexPath] {
                cacheManager.cancelImageRequest(requestID)
                imageRequestIDs.removeValue(forKey: indexPath)
            }
            
            cell.prepareForReuse()
            
            let requestID = cell.configure(
                with: asset,
                assetDetailed: assetDetailedStore.findOneBy(asset.id),
                targetSize: itemSize.multiplying(by: 3.5),
                cacheManager: cacheManager,
                options: imageRequestOptions
            )
            if let requestID = requestID {
                imageRequestIDs[indexPath] = requestID
            }
            
            return cell
        }
        
        // MARK: UICollectionViewDelegate
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard indexPath.item < assets.count else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let asset = self.assets[indexPath.item]
                self.onAssetSelected(asset)
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if let requestID = imageRequestIDs[indexPath] {
                cacheManager.cancelImageRequest(requestID)
                imageRequestIDs.removeValue(forKey: indexPath)
            }
            
            if indexPath.item < assets.count {
                let asset = assets[indexPath.item]
                let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                let itemSize = layout?.itemSize.multiplying(by: 3.5) ?? CGSize(width: 100, height: 100)
                cacheManager.stopCachingImages(for: [asset], targetSize: itemSize, contentMode: .aspectFill, options: nil)
            }
        }
        
        // MARK: UICollectionViewDataSourcePrefetching
        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            let prefetchIndexPaths = indexPaths.prefix(10)
            let assets = prefetchIndexPaths.compactMap { indexPath -> PHAsset? in
                guard indexPath.item < self.assets.count else { return nil }
                return self.assets[indexPath.item]
            }
            
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let itemSize = layout?.itemSize ?? CGSize(width: 100, height: 100)
            
            cacheManager.startCachingImages(for: assets, targetSize: itemSize, contentMode: .aspectFill, options: imageRequestOptions)
        }
        
        public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
            let assets = indexPaths.compactMap { indexPath -> PHAsset? in
                guard indexPath.item < self.assets.count else { return nil }
                return self.assets[indexPath.item]
            }
            
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let itemSize = layout?.itemSize ?? CGSize(width: 100, height: 100)
            
            cacheManager.stopCachingImages(for: assets, targetSize: itemSize, contentMode: .aspectFill, options: nil)
            
            for indexPath in indexPaths {
                if let requestID = imageRequestIDs[indexPath] {
                    cacheManager.cancelImageRequest(requestID)
                    imageRequestIDs.removeValue(forKey: indexPath)
                }
            }
        }
    }
}

public struct PhotoCollectionViewWithFrame: View {
    let assets: [PHAsset]
    let itemSpacing: CGFloat
    let onAssetSelected: (PHAsset) -> Void
    
    public init(
        assets: [PHAsset],
        itemSpacing: CGFloat,
        onAssetSelected: @escaping (PHAsset) -> Void
    ) {
        self.assets = assets
        self.itemSpacing = itemSpacing
        self.onAssetSelected = onAssetSelected
    }
    
    public var body: some View {
        PhotoCollectionView(
            assets: assets,
            itemSpacing: itemSpacing,
            onAssetSelected: onAssetSelected
        )
        .frame(height: calculateHeight())
    }
    
    private func calculateHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = itemSpacing * 6
        let itemWidth = (screenWidth - totalSpacing) / 5
        
        let numberOfRows = ceil(Double(assets.count) / 5.0)
        let totalHeight = (itemWidth * CGFloat(numberOfRows)) +
                         (itemSpacing * CGFloat(numberOfRows + 1))
        
        return totalHeight
    }
}
