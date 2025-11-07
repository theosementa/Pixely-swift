//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 07/11/2025.
//

import Foundation
import Models
import SwiftUI

extension SubAlbumModel {
    
    public func toAlbum() -> AlbumModel {
        return .init(
            id: id,
            name: name,
            emoji: emoji,
            color: color
        )
    }
    
}
