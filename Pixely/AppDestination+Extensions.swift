//
//  AppDestination+Extensions.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Navigation
import SwiftUI

import Albums

extension AppDestination {
    
    @ViewBuilder
    static func view(for destination: AppDestination) -> some View {
        switch destination {
        case .album(let albumDestination):
            albumView(for: albumDestination)
        }
    }
    
}

extension AppDestination {
    
    @ViewBuilder
    private static func albumView(for destination: AlbumDestination) -> some View {
        switch destination {
        case .list:
            AlbumsListScreen()
        default:
            EmptyView()
        }
    }
    
}
