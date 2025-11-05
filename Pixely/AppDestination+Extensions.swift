//
//  AppDestination+Extensions.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Navigation
import SwiftUI

import PhotoAsset
import Albums
import Gallery

extension AppDestination {
    
    @ViewBuilder
    static func view(for destination: AppDestination) -> some View {
        switch destination {
        case .album(let albumDestination):
            albumView(for: albumDestination)
        case .gallery(let galeryDestination):
            galleryView(for: galeryDestination)
        }
    }
    
}

extension AppDestination {
    
    @ViewBuilder
    private static func albumView(for destination: AlbumDestination) -> some View {
        switch destination {
        case .list:
            AlbumsListScreen()
        case .create:
            AddAlbumScreen()
        case .update(let albumId):
            AddAlbumScreen(albumId: albumId)
        case .detail(let albumId):
            AlbumDetailScreen(albumId: albumId)
        }
    }
    
    @ViewBuilder
    private static func galleryView(for destination: GalleryDestination) -> some View {
        switch destination {
        case .gallery:
            GalleryScreen()
        case .assetDetail(let asset):
            AssetDetailScreen(asset: asset)
        }
    }
    
}
