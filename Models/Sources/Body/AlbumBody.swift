//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation

public struct AlbumBody: BodyProtocol {
    public var id: UUID?
    public var name: String?
    public var emoji: String?
    public var colorHex: String?
}

public extension AlbumBody {
    
    static func create(
        name: String,
        emoji: String? = nil,
        colorHex: String
    ) -> AlbumBody {
        return .init(
            name: name,
            emoji: emoji,
            colorHex: colorHex
        )
    }
    
    static func update(
        id: UUID,
        name: String? = nil,
        emoji: String? = nil,
        colorHex: String? = nil
    ) -> AlbumBody {
        return .init(
            id: id,
            name: name ?? "",
            emoji: emoji ?? "",
            colorHex: colorHex ?? ""
        )
    }
    
}
