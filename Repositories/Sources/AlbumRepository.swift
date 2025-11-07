//
//  File.swift
//  Repositories
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Persistence

public struct AlbumRepository: RepositoryProtocol {
    public typealias Entity = AlbumEntity
}

extension AlbumRepository {
    
    public static func fetchAll() throws -> [AlbumEntity] {
        let request = Entity.fetchRequest()
        return try CoreDataStack.shared.viewContext.fetch(request)
    }
    
    public static func fetchAssetCount(for album: any AlbumProtocol) throws -> Int {
        let entity = try AlbumRepository.fetchOne(id: album.id)
        let request = AssetDetailedEntity.fetchRequest()
        request.predicate = NSPredicate(format: "album == %@", entity)
        
        return try CoreDataStack.shared.viewContext.count(for: request)
    }
    
    public static func create(body: AlbumBody) throws -> AlbumEntity {
        let album = AlbumEntity(context: CoreDataStack.shared.viewContext)
        album.id = UUID()
        album.name = body.name ?? ""
        album.emoji = body.emoji
        album.colorHex = body.colorHex ?? ""
        album.subAlbumsIds = []
        if let parentAlbumModel = body.parentAlbum {
            let parentAlbumEntity = try fetchOne(id: parentAlbumModel.id)
            parentAlbumEntity.subAlbumsIds.append(album.id.uuidString)
        }
        
        try CoreDataStack.shared.viewContext.save()
        return album
    }
    
    public static func update(body: AlbumBody, isNewParentAlbum: Bool = false) throws -> AlbumEntity {
        guard let albumId = body.id else { throw RepositoryError.notFound }
        
        let album = try fetchOne(id: albumId)
        album.name = body.name ?? ""
        album.emoji = body.emoji
        album.colorHex = body.colorHex ?? ""
        if isNewParentAlbum {
            album.subAlbumsIds = []
        } else if let parentAlbumModel = body.parentAlbum {
            let parentAlbumEntity = try fetchOne(id: parentAlbumModel.id)
            parentAlbumEntity.subAlbumsIds.append(album.id.uuidString)
        }
        
        try CoreDataStack.shared.viewContext.save()
        return album
    }
}
