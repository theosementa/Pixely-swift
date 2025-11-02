//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import SwiftUI

public struct AlbumModel: Identifiable {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var color: Color
    
    public init(
        id: UUID,
        name: String,
        emoji: String,
        color: Color
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
    }
}
