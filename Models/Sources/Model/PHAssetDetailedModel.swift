//
//  PHAssetDetailedModel.swift
//  Models
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import CoreLocation

public struct PHAssetDetailedModel {
    public var album: AlbumModel?
    public var assetId: String? // AssetId

    public var model: String? // TIFF
    public var make: String? // TIFF
    public var software: String? // TIFF
    public var dateTime: String? // TIFF - ex: 2025:05:12 06:55:33

    public var latitude: Double? // GPS
    public var longitude: Double? // GPS

    public var focal: Int? // FocalLenIn35mmFilm
    public var opening: String? // LensModel - f/1.78

    public var fileSize: Int?
    public var pixelWidth: Int? // PiwelWidth
    public var pixelHeight: Int? // PixelHeight
    
    public init(
        album: AlbumModel? = nil,
        assetId: String? = nil,
        model: String? = nil,
        make: String? = nil,
        software: String? = nil,
        dateTime: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        focal: Int? = nil,
        opening: String? = nil,
        fileSize: Int? = nil,
        pixelWidth: Int? = nil,
        pixelHeight: Int? = nil
    ) {
        self.album = album
        self.assetId = assetId
        self.model = model
        self.make = make
        self.software = software
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.focal = focal
        self.opening = opening
        self.fileSize = fileSize
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
    }
}

public extension PHAssetDetailedModel {
    
    var device: String {
        guard let make, let model else { return "Unknown device" }
        if let software {
            return "\(make) \(model) (\(software))"
        }
        return "\(make) \(model)"
    }
    
    var dimensions: String {
        guard let pixelWidth, let pixelHeight else { return "Unknown size" }
        return "\(pixelWidth) x \(pixelHeight)"
    }
    
    var date: Date {
//        return dateTime?.exifToDate() ?? .now // TODO: Reactive
        return .now
    }
    
    var coordinates: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return .init(latitude: latitude, longitude: longitude)
    }
    
}

extension PHAssetDetailedModel {
 
    public func toBody(album: AlbumModel) -> AssetDetailledBody? {
        guard let assetId else { return nil }
        return AssetDetailledBody(
            assetId: assetId,
            album: album,
            model: model,
            make: make,
            software: software,
            dateTime: dateTime,
            latitude: latitude,
            longitude: longitude,
            focal: focal,
            opening: opening,
            fileSize: fileSize,
            pixelWidth: pixelWidth,
            pixelHeight: pixelHeight
        )
    }
    
}
