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

public final class AlbumRepository: GenericRepository<AlbumEntity> {
    
    public func fetchOne(id: UUID) throws -> AlbumEntity {
        let predicate = #Predicate<AlbumEntity> { $0.id == id }
        
        var fetchDescriptor = FetchDescriptor<AlbumEntity>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        let results = try container.mainContext.fetch(fetchDescriptor)
        
        guard let entity = results.first else { throw RepositoryError.notFound }
        return entity
    }
    
    public func create(body: AlbumBody) throws -> AlbumEntity {
        let album = AlbumEntity(
            id: UUID(),
            name: body.name ?? "",
            emoji: body.emoji,
            colorHex: body.colorHex ?? "",
            isParentAlbum: body.parentAlbum == nil ? true : false,
            subAlbumsIds: [],
            notes: nil,
            assets: []
        )
        
        if let parentAlbumModel = body.parentAlbum {
            let parentAlbumEntity = try fetchOne(id: parentAlbumModel.id)
            parentAlbumEntity.subAlbumsIds.append(album.id.uuidString)
        }
        
        try self.insert(album)
        
        return album
    }
    
    public func update(body: AlbumBody, isNewParentAlbum: Bool = false) throws -> AlbumEntity {
        guard let albumId = body.id else { throw RepositoryError.notFound }
        
        let album = try fetchOne(id: albumId)
        album.name = body.name ?? ""
        album.emoji = body.emoji
        album.colorHex = body.colorHex ?? ""
        if isNewParentAlbum {
            album.subAlbumsIds = []
            album.isParentAlbum = true
        } else if let parentAlbumModel = body.parentAlbum {
            let parentAlbumEntity = try fetchOne(id: parentAlbumModel.id)
            parentAlbumEntity.subAlbumsIds.append(album.id.uuidString)
        }
        
        try self.insert(album)
        return album
    }
        
    public func fetchAssetCount(for album: any AlbumProtocol) throws -> Int {
        let albumID = album.id
            
        let predicate = #Predicate<AssetDetailedEntity> { $0.album?.id == albumID }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        
        let results = try container.mainContext.fetchCount(fetchDescriptor)
        return results
    }
    
    public func delete(id: UUID) throws {
        let entity = try fetchOne(id: id)
        try self.delete(entity)
    }
    
}
