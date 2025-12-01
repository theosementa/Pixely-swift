//
//  PHAssetHelper.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Photos
import Models
import Utilities

final class PHAssetHelper {
    /// Récupère les détails complets d'un PHAsset de manière asynchrone
    static func detailed(for asset: PHAsset, completion: @escaping (PHAssetDetailedModel) -> Void) {
        var detailedAsset = PHAssetDetailedModel(playbackStyle: asset.playbackStyle)
        detailedAsset.assetId = asset.id
        
        let group = DispatchGroup()
        
        group.enter()
        AccurateFileSizeHelper.getAccurateFileSize(asset: asset) { sizeInBytes, _ in
            detailedAsset.fileSize = sizeInBytes
            group.leave()
        }
        
        group.enter()
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        PHImageManager
            .default()
            .requestImageDataAndOrientation(
                for: asset,
                options: options
            ) { imageData, _, _, _ in
                guard let imageData = imageData,
                      let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                      let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
                    group.leave()
                    return
                }
                
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
                
                //            if let exifAuxMetadata = metadata[("ExifAux" as CFString) as String] as? [String: Any] {
                //                detailedAsset.focalLength = exifAuxMetadata["LensModel"] as? String
                //            }
                //
                group.leave()
            }
        
        // Notification une fois toutes les tâches terminées
        group.notify(queue: .main) {
            completion(detailedAsset)
        }
    }
    
    // Méthode de debug pour imprimer les métadonnées complètes
    static func printFullMetadata(for asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        PHImageManager
            .default()
            .requestImageDataAndOrientation(
                for: asset,
                options: options
            ) { imageData, _, _, _ in
                guard let imageData = imageData,
                      let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                      let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
                    return
                }
                
                print("Métadonnées complètes:")
                self.printFormattedMetadata(metadata)
            }
    }
    
    // Méthode utilitaire pour imprimer les métadonnées de manière formatée
    private static func printFormattedMetadata(_ metadata: [String: Any], indent: Int = 0) {
        let indentString = String(repeating: "  ", count: indent)
        
        for (key, value) in metadata {
            if let nestedDict = value as? [String: Any] {
                print("\(indentString)\(key):")
                printFormattedMetadata(nestedDict, indent: indent + 1)
            } else {
                print("\(indentString)\(key): \(value)")
            }
        }
    }
}

class AccurateFileSizeHelper {
    
    /// Récupère la taille précise de l'image à partir d'un PHAsset
    static func getAccurateFileSize(asset: PHAsset, completion: @escaping (Int?, Bool) -> Void) {
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        // Méthode 1 : Utiliser les ressources originales de l'asset
        if let resource = PHAssetResource.assetResources(for: asset).first {
            let sizeInBytes = Int(resource.value(forKey: "fileSize") as? Int64 ?? 0)
            if sizeInBytes > 0 {
                completion(sizeInBytes, true)
                return
            }
        }
        
        // Méthode 2 : Récupération des données complètes
        PHImageManager
            .default()
            .requestImageDataAndOrientation(
                for: asset,
                options: options
            ) { imageData, _, _, _ in
                let imageSize = imageData?.count ?? 0
                completion(imageSize > 0 ? imageSize : nil, false)
            }
    }
    
}
