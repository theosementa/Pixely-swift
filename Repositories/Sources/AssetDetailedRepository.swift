//
//  File.swift
//  Repositories
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Persistence
import SwiftData

public final class AssetDetailedRepository: GenericRepository<AssetDetailedEntity> {
    
    public func fetchOne(id: UUID) throws -> AssetDetailedEntity {
        let predicate = #Predicate<AssetDetailedEntity> { $0.id == id }
        
        var fetchDescriptor = FetchDescriptor<AssetDetailedEntity>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        let results = try container.mainContext.fetch(fetchDescriptor)
        
        guard let entity = results.first else { throw RepositoryError.notFound }
        return entity
    }
    
    public func fetchOneEntity(phAssetId: String) throws -> AssetDetailedEntity? {
        let predicate = #Predicate<AssetDetailedEntity> { $0.assetId == phAssetId }
        
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        let results = try container.mainContext.fetch(fetchDescriptor)

        guard let entity = results.first else { throw RepositoryError.notFound }
        return entity
    }

    public func create(body: AssetDetailledBody) throws -> AssetDetailedEntity {
        guard let albumId = body.album?.id, let assetId = body.assetId else { throw RepositoryError.notFound }
        let album = try AlbumRepository().fetchOne(id: albumId)
                
        let entity = AssetDetailedEntity(
            id: UUID(),
            assetId: assetId,
            title: body.title,
            make: body.make,
            model: body.model,
            software: body.software,
            dateTime: body.dateTime,
            legend: "",
            focal: body.focal,
            opening: body.opening,
            latitude: body.latitude,
            longitude: body.longitude,
            fileSize: body.fileSize,
            pixelHeight: body.pixelHeight,
            pixelWidth: body.pixelWidth,
            playbackStyleRawValue: body.playbackStyleRawValue,
            album: album,
            tags: []
        )
        
        try self.insert(entity)
        return entity
    }
    
    public func update(body: AssetDetailledBody) throws -> AssetDetailedEntity {
        guard let album = body.album else { throw RepositoryError.notFound }
        guard let assetId = body.id else { throw RepositoryError.notFound }
        
        let asset = try fetchOne(id: assetId)
        asset.album = try AlbumRepository().fetchOne(id: album.id)
        
        try self.insert(asset)
        return asset
    }
    
}
