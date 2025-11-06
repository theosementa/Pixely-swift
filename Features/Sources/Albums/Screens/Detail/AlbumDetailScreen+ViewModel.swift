//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import Stores
import Dependencies
import Models

extension AlbumDetailScreen {
    
    @MainActor @Observable
    final class ViewModel {
        
        var albumId: UUID
        var album: AlbumModel?
        
        @ObservationIgnored
        @Dependency(\.albumStore) var albumStore
        
        init(albumId: UUID) {
            self.albumId = albumId
            if let currentAlbum = albumStore.fetchOne(id: albumId) {
                self.album = currentAlbum
            }
        }
        
    }
    
}
