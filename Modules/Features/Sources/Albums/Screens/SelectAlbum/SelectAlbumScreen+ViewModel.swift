//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 03/12/2025.
//

import Foundation
import Models
import Dependencies

extension SelectAlbumScreen {
    
    @Observable @MainActor
    final class ViewModel {
        
        @ObservationIgnored
        @Dependency(\.albumStore) private var albumStore
        
        var albumSelectedId: UUID
        
        init(albumSelectedId: UUID) {
            self.albumSelectedId = albumSelectedId
        }
    }
    
}

// MARK: - Computed variables
extension SelectAlbumScreen.ViewModel {
    
    var parentAlbumsSelectable: [AlbumModel] {
        var parentsAlbums = albumStore.parentAlbums
            .sorted { $0.name < $1.name }
        parentsAlbums.insert(.noAlbum, at: 0)
        return parentsAlbums
    }
    
    var subAlbumsSelectable: [SubAlbumModel] {
        return albumStore.subAlbums
            .sorted { $0.name < $1.name }
    }
    
    var albumSelected: AlbumModel? {
        return albumStore.fetchOne(id: albumSelectedId)
    }
}
