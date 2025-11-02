//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import NavigationKit

public enum AlbumDestination: DestinationItem {
    case list
    case create
    case update(albumId: UUID)
    case detail(albumId: UUID)
}
