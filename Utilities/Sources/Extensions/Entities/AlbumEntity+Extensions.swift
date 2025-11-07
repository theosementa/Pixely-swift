//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 06/11/2025.
//

import Foundation
import Models
import SwiftUI

extension AlbumEntity {
    
    public func toModel() -> AlbumModel {
        return .init(
            id: id,
            name: name,
            emoji: emoji ?? "",
            color: Color(hex: colorHex),
            subAlbumsIds: subAlbumsIds
        )
    }
    
    public func toSubAlbum(parentId: UUID) -> SubAlbumModel {
        return .init(
            id: id,
            name: name,
            emoji: emoji ?? "",
            color: Color(hex: colorHex),
            parentAlbumId: parentId
        )
    }
    
}
