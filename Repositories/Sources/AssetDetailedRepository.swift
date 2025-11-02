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
        guard let albumId = body.albumId else { throw RepositoryError.notFound }
        let album = try AlbumRepository.fetchOne(id: albumId)
        
        let asset = AssetDetailedEntity(context: CoreDataStack.shared.viewContext)
        asset.id = UUID()
        asset.assetId = body.assetId ?? ""
        asset.album = album
        
        try CoreDataStack.shared.viewContext.save()
        return asset
    }
    
    public static func update(body: AssetDetailledBody) throws -> AssetDetailedEntity {
        guard let album = body.album else { throw RepositoryError.notFound }
        guard let assetId = body.id else { throw RepositoryError.notFound }
        
        let asset = try fetchOne(id: assetId)
        asset.album = album
        
        try CoreDataStack.shared.viewContext.save()
        return asset
    }
    
}
