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
    public static func create(body: AlbumBody) throws -> AlbumEntity {
        let album = AlbumEntity(context: CoreDataStack.shared.viewContext)
        album.id = UUID()
        album.name = body.name ?? ""
        album.emoji = body.emoji
        album.colorHex = body.colorHex ?? ""
        
        try CoreDataStack.shared.viewContext.save()
        return album
    }
    
    public static func update(body: AlbumBody) throws -> AlbumEntity {
        guard let albumId = body.id else { throw RepositoryError.notFound }
        
        let album = try fetchOne(id: albumId)
        album.name = body.name ?? ""
        album.emoji = body.emoji
        album.colorHex = body.colorHex ?? ""
        
        try CoreDataStack.shared.viewContext.save()
        return album
    }
}
