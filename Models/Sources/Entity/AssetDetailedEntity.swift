//
//  AssetDetailedEntity.swift
//  Pixely
//
//  Created by Theo Sementa on 08/11/2025.
//
//

import Foundation
import SwiftData

@Model
public class AssetDetailedEntity {
    
    public var id: UUID
    
    public var assetId: String
    
    public var title: String?
    
    public var make: String?
    
    public var model: String?
    
    public var software: String?
    
    public var dateTime: String?
    
    public var legend: String?
    
    public var focal: Int?
    
    public var opening: String?
    
    public var latitude: Double?
    
    public var longitude: Double?
    
    public var fileSize: Int?
    
    public var pixelHeight: Int?
    
    public var pixelWidth: Int?
    
    public var playbackStyleRawValue: Int?
    
    public var album: AlbumEntity?
    
    @Relationship(inverse: \TagEntity.assets)
    public var tags: [TagEntity]?
    
    public init(
        id: UUID,
        assetId: String,
        title: String? = nil,
        make: String? = nil,
        model: String? = nil,
        software: String? = nil,
        dateTime: String? = nil,
        legend: String? = nil,
        focal: Int? = nil,
        opening: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        fileSize: Int? = nil,
        pixelHeight: Int? = nil,
        pixelWidth: Int? = nil,
        playbackStyleRawValue: Int? = nil,
        album: AlbumEntity? = nil,
        tags: [TagEntity]? = nil
    ) {
        self.id = id
        self.assetId = assetId
        self.title = title
        self.make = make
        self.model = model
        self.software = software
        self.dateTime = dateTime
        self.legend = legend
        self.focal = focal
        self.opening = opening
        self.latitude = latitude
        self.longitude = longitude
        self.fileSize = fileSize
        self.pixelHeight = pixelHeight
        self.pixelWidth = pixelWidth
        self.playbackStyleRawValue = playbackStyleRawValue
        self.album = album
        self.tags = tags
    }
    
}
