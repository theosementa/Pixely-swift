//
//  PHAssetHelper.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Photos
import Models
import Utilities

public final class PHAssetHelper {

    public static func detailed(for asset: PHAsset) async -> PHAssetDetailedModel {
        var detailedAsset = PHAssetDetailedModel(playbackStyle: asset.playbackStyle)
        detailedAsset.assetId = asset.id
        
        async let fileSize = AccurateFileSizeHelper.getAccurateFileSize(asset: asset)
        async let metadata = fetchMetadata(for: asset)
        
        let (sizeInBytes, _) = await fileSize
        detailedAsset.fileSize = sizeInBytes
        
        if let metadata = await metadata {
            // Extraction des métadonnées TIFF
            if let tiffMetadata = metadata[kCGImagePropertyTIFFDictionary as String] as? [String: Any] {
                detailedAsset.model = tiffMetadata["Model"] as? String
                detailedAsset.make = tiffMetadata["Make"] as? String
                detailedAsset.software = tiffMetadata["Software"] as? String
                detailedAsset.dateTime = tiffMetadata["DateTime"] as? String
            }
            
            // Extraction des métadonnées GPS
            if let gpsMetadata = metadata[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
                detailedAsset.latitude = gpsMetadata["Latitude"] as? Double
                detailedAsset.longitude = gpsMetadata["Longitude"] as? Double
            }
            
            // Extraction des métadonnées EXIF
            if let exifMetadata = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any] {
                detailedAsset.focal = exifMetadata["FocalLenIn35mmFilm"] as? Int
                detailedAsset.opening = (exifMetadata["LensModel"] as? String)?.removeAllBefore("f/")
            }
            
            // Extraction des dimensions
            detailedAsset.pixelWidth = metadata["PixelWidth"] as? Int
            detailedAsset.pixelHeight = metadata["PixelHeight"] as? Int
        }
        
        return detailedAsset
    }
    
    /// Récupère les métadonnées d'un PHAsset
    private static func fetchMetadata(for asset: PHAsset) async -> [String: Any]? {
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        return await withCheckedContinuation { continuation in
            PHImageManager
                .default()
                .requestImageDataAndOrientation(
                    for: asset,
                    options: options
                ) { imageData, _, _, _ in
                    guard let imageData = imageData,
                          let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                          let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    continuation.resume(returning: metadata)
                }
        }
    }

}

class AccurateFileSizeHelper {
    
    static func getAccurateFileSize(asset: PHAsset) async -> (Int?, Bool) {
        if let resource = PHAssetResource.assetResources(for: asset).first {
            let sizeInBytes = Int(resource.value(forKey: "fileSize") as? Int64 ?? 0)
            if sizeInBytes > 0 {
                return (sizeInBytes, true)
            }
        }
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        return await withCheckedContinuation { continuation in
            PHImageManager
                .default()
                .requestImageDataAndOrientation(
                    for: asset,
                    options: options
                ) { imageData, _, _, _ in
                    let imageSize = imageData?.count ?? 0
                    continuation.resume(returning: (imageSize > 0 ? imageSize : nil, false))
                }
        }
    }
}
