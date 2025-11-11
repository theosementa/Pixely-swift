//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import SwiftUI

public struct AlbumModel: AlbumProtocol, Sendable {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var isParentAlbum: Bool
    public var subAlbumsIds: [String]?
    public var subAlbums: [SubAlbumModel]?
    
    public init(
        id: UUID,
        name: String,
        emoji: String,
        isParentAlbum: Bool,
        subAlbumsIds: [String]? = nil,
        subAlbums: [SubAlbumModel]? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isParentAlbum = isParentAlbum
        self.subAlbums = subAlbums
        self.subAlbumsIds = subAlbumsIds
    }
}

public struct SubAlbumModel: AlbumProtocol, Sendable {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var parentAlbumId: UUID
    
    public init(
        id: UUID,
        name: String,
        emoji: String,
        parentAlbumId: UUID
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.parentAlbumId = parentAlbumId
    }
}

// MARK: - Mocks
extension AlbumModel {
    
    public static let noAlbum: AlbumModel = .init(
        id: UUID(),
        name: "Aucun album",
        emoji: "🐀",
        isParentAlbum: true
    )
    
    public static let mock: AlbumModel = .init(
        id: UUID(),
        name: "Mock album",
        emoji: "🐀",
        isParentAlbum: true
    )
    
}
