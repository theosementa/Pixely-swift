//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import UIKit
import Photos
import SwiftUI
import Models

final class CachedImageManager {
    
    @MainActor let imageManager = PHCachingImageManager()
    private var imageContentMode = PHImageContentMode.aspectFit
    
    private var cachedAssetIdentifiers: [String: Bool] = [:]
    
    private lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        return options
    }()
    
    init() {
        imageManager.allowsCachingHighQualityImages = false
    }
}

// MARK: - Caching
extension CachedImageManager {
    
    var cachedImageCount: Int {
        return cachedAssetIdentifiers.keys.count
    }
    
    func startCaching(for phAssets: [PHAsset], targetSize: CGSize) {
        phAssets.forEach {
            cachedAssetIdentifiers[$0.localIdentifier] = true
        }
        imageManager.startCachingImages(
            for: phAssets,
            targetSize: targetSize,
            contentMode: imageContentMode,
            options: requestOptions
        )
    }

    func stopCaching(for phAssets: [PHAsset], targetSize: CGSize) {
        phAssets.forEach {
            cachedAssetIdentifiers.removeValue(forKey: $0.localIdentifier)
        }
        imageManager.stopCachingImages(
            for: phAssets,
            targetSize: targetSize,
            contentMode: imageContentMode,
            options: requestOptions
        )
    }
    
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
}

// MARK: - Request
extension CachedImageManager {
    
    func requestImage(for phAsset: PHAsset, targetSize: CGSize) async throws -> ImageRequestResult {
        var requestId: PHImageRequestID?
        
        let imageWithInfo: ImageWithInfoModel = await withCheckedContinuation { continuation in
            var nillableContinuation: CheckedContinuation<ImageWithInfoModel, Never>? = continuation
            requestId = imageManager.requestImage(
                for: phAsset,
                targetSize: targetSize,
                contentMode: imageContentMode,
                options: requestOptions
            ) { image, info in
                nillableContinuation?.resume(returning: .init(image: image, info: info))
                nillableContinuation = nil
            }
        }
        
        if let error = imageWithInfo.info?[PHImageErrorKey] as? Error {
            print("CachedImageManager requestImage error: \(error.localizedDescription)")
            throw CachedImageError.error(error)
        } else if let cancelled = (imageWithInfo.info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
            print("CachedImageManager request canceled")
            throw CachedImageError.cancelled
        }
        
        if let image = imageWithInfo.image {
            let isLowerQualityImage = (imageWithInfo.info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
            let result = ImageRequestResult(requestId: requestId, image: Image(uiImage: image), isLowerQuality: isLowerQualityImage)
            return result
        } else {
            throw CachedImageError.failed
        }
    }
    
    func requestImageData(for phAsset: PHAsset) async throws -> ImageDataRequestResult {
        var requestId: PHImageRequestID?
        let imageDataWithInfo: ImageDataWithInfoModel = await withCheckedContinuation { continuation in
            var nillableContinuation: CheckedContinuation<ImageDataWithInfoModel, Never>? = continuation
            requestId = imageManager.requestImageDataAndOrientation(
                for: phAsset,
                options: nil
            ) { imageData, dataUTI, orientation, info in
                nillableContinuation?.resume(
                    returning: .init(
                        data: imageData,
                        dataUTI: dataUTI,
                        orientation: orientation,
                        info: info
                    )
                )
                nillableContinuation = nil
            }
        }
        
        print(imageDataWithInfo.dataUTI ?? "uniform type identifiers not available")
        
        if let error = imageDataWithInfo.info?[PHImageErrorKey] as? Error {
            print("CachedImageManager requestImage error: \(error.localizedDescription)")
            throw CachedImageError.error(error)
        } else if let cancelled = (imageDataWithInfo.info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
            print("CachedImageManager request canceled")
            throw CachedImageError.cancelled
        }
        
        if let imageData = imageDataWithInfo.data {
            let result = ImageDataRequestResult(
                requestId: requestId,
                dataUTI: imageDataWithInfo.dataUTI,
                imageData: imageData
            )
            return result
        } else {
            throw CachedImageError.failed
        }
    }
    
    func requestVideoPlayback(for phAsset: PHAsset) async throws -> VideoPlaybackRequestResult {
        var requestId: PHImageRequestID?
        
        let videoWithInfo: VideoWithInfoModel = await withCheckedContinuation { continuation in
            var nillableContinuation: CheckedContinuation<VideoWithInfoModel, Never>? = continuation
            
            let option = PHVideoRequestOptions()
            option.deliveryMode = .highQualityFormat
            requestId = imageManager.requestPlayerItem(
                forVideo: phAsset,
                options: option
            ) { playerItem, info in
                nillableContinuation?.resume(returning: .init(player: playerItem, info: info))
                nillableContinuation = nil
            }
        }
        
        if let error = videoWithInfo.info?[PHImageErrorKey] as? Error {
            print("CachedImageManager requestImage error: \(error.localizedDescription)")
            throw CachedImageError.error(error)
        } else if let cancelled = (videoWithInfo.info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
            print("CachedImageManager request canceled")
            throw CachedImageError.cancelled
        }
        
        if let playerItem = videoWithInfo.player {
            let result = VideoPlaybackRequestResult(requestId: requestId, playerItem: playerItem)
            return result
        } else {
            throw CachedImageError.failed
        }
    }
    
    func cancelImageRequest(for requestID: PHImageRequestID) {
        imageManager.cancelImageRequest(requestID)
    }
}
