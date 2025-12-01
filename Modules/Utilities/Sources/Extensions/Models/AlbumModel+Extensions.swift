//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 07/11/2025.
//

import Foundation
import Models
import SwiftUI

extension AlbumModel {
    
    public func toSubAlbum(parentId: UUID) -> SubAlbumModel {
        return .init(
            id: id,
            name: name,
            emoji: emoji,
            parentAlbumId: parentId
        )
    }
    
}
