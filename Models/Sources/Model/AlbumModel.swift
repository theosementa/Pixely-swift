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
    public var color: Color
    public var subAlbumsIds: [String]?
    public var subAlbums: [SubAlbumModel]?
    
    public init(
        id: UUID,
        name: String,
        emoji: String,
        color: Color,
        subAlbumsIds: [String]? = nil,
        subAlbums: [SubAlbumModel]? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.subAlbums = subAlbums
        self.subAlbumsIds = subAlbumsIds
    }
}

public struct SubAlbumModel: AlbumProtocol, Sendable {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var color: Color
    public var parentAlbumId: UUID
    
    public init(
        id: UUID,
        name: String,
        emoji: String,
        color: Color,
        parentAlbumId: UUID
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.parentAlbumId = parentAlbumId
    }
}

// MARK: - Mocks
extension AlbumModel {
    
    public static let noAlbum: AlbumModel = .init(
        id: UUID(),
        name: "Aucun album",
        emoji: "🐀",
        color: .gray
    )
    
    public static let mock: AlbumModel = .init(
        id: UUID(),
        name: "Mock album",
        emoji: "🐀",
        color: .red
    )
    
}
