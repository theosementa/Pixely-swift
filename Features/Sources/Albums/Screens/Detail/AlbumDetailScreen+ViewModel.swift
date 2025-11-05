//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import Stores
import Dependencies

extension AlbumDetailScreen {
    
    @Observable
    final class ViewModel {
        
        var albumId: UUID
        
        @ObservationIgnored
        @Dependency(\.albumStore) var albumStore
        
        init(albumId: UUID) {
            self.albumId = albumId
        }
        
    }
    
}
