//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Dependencies
import Models

extension AddAlbumScreen {
    
    @Observable
    final class ViewModel {
        
        var name: String = ""
        var emoji: String = ""
        var colorHex: String = ""
        
        @ObservationIgnored
        @Dependency(\.albumStore) private var albumStore
        
        init(albumId: UUID?) {
            
        }
        
    }
    
}

extension AddAlbumScreen.ViewModel {
    
    var isBodyValid: Bool {
        return !name.isEmpty
    }
    
}

// MARK: - Public functions
extension AddAlbumScreen.ViewModel {
    
    @MainActor
    public func createAlbum() {
        guard isBodyValid else { return }
        
        let body: AlbumBody = .create(
            name: name,
            emoji: emoji,
            colorHex: colorHex.isEmpty ? "FF0000" : colorHex
        )
        
        albumStore.create(body: body)
    }
    
}
