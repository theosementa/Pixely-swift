//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import NavigationKit
import Models
import SwiftUI

public enum AlbumDestination: DestinationItem {
    case list
    case create
    case createSubAlbum(parentAlbum: AlbumModel)
    case selectAlbum(albumSelectedId: Binding<UUID>)
    case update(albumId: UUID)
    case detail(albumId: UUID)
}
