//
//  File.swift
//  Repositories
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Persistence

public struct AssetDetailedRepository: RepositoryProtocol {
    public typealias Entity = AssetDetailedEntity
}

extension AssetDetailedRepository {
    
    public static func create(body: AssetDetailledBody) throws -> AssetDetailedEntity {
        guard let albumId = body.album?.id, let assetId = body.assetId else { throw RepositoryError.notFound }
        let album = try AlbumRepository.fetchOne(id: albumId)
                
        let entity = AssetDetailedEntity(context: CoreDataStack.shared.viewContext)
        entity.id = UUID()
        entity.assetId = assetId
        entity.title = body.title
        entity.album = album
        
        entity.model = body.model
        entity.make = body.make
        entity.software = body.software
        entity.dateTime = body.dateTime
        
        entity.latitude = body.latitude ?? 0
        entity.longitude = body.longitude ?? 0
        
        entity.focal = Int64(body.focal ?? 0)
        entity.opening = body.opening
        
        entity.fileSize = Int64(body.fileSize ?? 0)
        entity.pixelWidth = Int64(body.pixelWidth ?? 0)
        entity.pixelHeight = Int64(body.pixelHeight ?? 0)
        
        try CoreDataStack.shared.viewContext.save()
        return entity
    }
    
    public static func update(body: AssetDetailledBody) throws -> AssetDetailedEntity {
        guard let album = body.album else { throw RepositoryError.notFound }
        guard let assetId = body.id else { throw RepositoryError.notFound }
        
        let asset = try fetchOne(id: assetId)
        asset.album = try AlbumRepository.fetchOne(id: album.id)
        
        try CoreDataStack.shared.viewContext.save()
        return asset
    }
    
    public static func fetchOneEntity(phAssetId: String) throws -> AssetDetailedEntity? {
        let request = AssetDetailedEntity.fetchRequest()
        request.predicate = NSPredicate(format: "assetId == %@", phAssetId)
        request.fetchLimit = 1
        
        let asset = try CoreDataStack.shared.viewContext.fetch(request)
        return asset.first
    }
    
}
