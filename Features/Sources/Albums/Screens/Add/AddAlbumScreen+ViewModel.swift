//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Dependencies
import Models
import SwiftUI
import Utilities

extension AddAlbumScreen {
    
    @Observable
    final class ViewModel {
        
        var name: String = ""
        var emoji: String = "🤖"
        var parentAlbum: AlbumModel?
        
        var isEmojiPickerPresented: Bool = false
        
        @ObservationIgnored
        @Dependency(\.albumStore) private var albumStore
        
        init(parentAlbum: AlbumModel? = nil, albumId: UUID?) {
            self.parentAlbum = parentAlbum
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
    public func createAlbum(dismiss: DismissAction) {
        guard isBodyValid else { return }
        
        let body: AlbumBody = .create(
            name: name,
            emoji: emoji,
            parentAlbum: parentAlbum
        )
        
        albumStore.create(body: body)
        dismiss()
    }
    
}
