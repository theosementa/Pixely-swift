//
//  AlbumEntity.swift
//  Pixely
//
//  Created by Theo Sementa on 08/11/2025.
//
//

import Foundation
import SwiftData

@Model
public class AlbumEntity {
    
    public var id: UUID
    
    public var name: String
    
    public var emoji: String?

    public var colorHex: String
    
    public var isParentAlbum: Bool
    
    public var subAlbumsIds: [String] = []
    
    public var notes: String?
    
    @Relationship(deleteRule: .cascade, inverse: \AssetDetailedEntity.album)
    public var assets: [AssetDetailedEntity]?
    
    public init(
        id: UUID,
        name: String,
        emoji: String? = nil,
        colorHex: String,
        isParentAlbum: Bool,
        subAlbumsIds: [String],
        notes: String? = nil,
        assets: [AssetDetailedEntity]? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.colorHex = colorHex
        self.isParentAlbum = isParentAlbum
        self.subAlbumsIds = subAlbumsIds
        self.notes = notes
        self.assets = assets
    }
    
}
