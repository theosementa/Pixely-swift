//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation

public struct AssetDetailledBody: BodyProtocol {
    public var id: UUID?
    public var assetId: String?
    public var title: String?
    public var albumId: UUID?
    public var album: AlbumEntity?
    
    public init(
        id: UUID? = nil,
        assetId: String? = nil,
        title: String? = nil,
        albumId: UUID? = nil,
        album: AlbumEntity? = nil
    ) {
        self.id = id
        self.assetId = assetId
        self.title = title
        self.albumId = albumId
        self.album = album
    }
}

public extension AssetDetailledBody {
    
    static func create(
        assetId: String,
        title: String? = nil,
        albumId: UUID
    ) -> AssetDetailledBody {
        return .init(
            assetId: assetId,
            title: title,
            albumId: albumId
        )
    }
    
    static func update(
        id: UUID,
        album: AlbumEntity
    ) -> AssetDetailledBody {
        return .init(
            id: id,
            album: album
        )
    }
    
}
