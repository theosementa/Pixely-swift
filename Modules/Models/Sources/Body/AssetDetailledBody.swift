//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import CoreData
import Photos

public struct AssetDetailledBody: BodyProtocol {
    public var id: UUID?
    public var assetId: String? // AssetId
    public var title: String?
    public var album: AlbumModel?
        
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
    
    public var playbackStyleRawValue: Int
    
    public init(
        id: UUID? = nil,
        assetId: String? = nil,
        title: String? = nil,
        albumId: UUID? = nil,
        album: AlbumModel? = nil,
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
        pixelHeight: Int? = nil,
        playbackStyleRawValue: Int
    ) {
        self.id = id
        self.assetId = assetId
        self.title = title
        self.album = album
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
        self.playbackStyleRawValue = playbackStyleRawValue
    }
}
