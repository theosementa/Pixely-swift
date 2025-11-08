//
//  TagEntity.swift
//  Pixely
//
//  Created by Theo Sementa on 08/11/2025.
//
//

import Foundation
import SwiftData

@Model
public class TagEntity {
    
    public var id: UUID
    
    public var name: String
    
    public var emoji: String?
    
    public var colorHex: String?
    
    public var assets: [AssetDetailedEntity]?
    
    public init(
        id: UUID,
        name: String,
        emoji: String? = nil,
        colorHex: String? = nil,
        assets: [AssetDetailedEntity]? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.colorHex = colorHex
        self.assets = assets
    }
}
