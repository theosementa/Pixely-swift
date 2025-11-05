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
import Extensions

extension AddAlbumScreen {
    
    @Observable
    final class ViewModel {
        
        var name: String = ""
        var emoji: String = "🤖"
        var color: Color = .red
        
        var isEmojiPickerPresented: Bool = false
        
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
            colorHex: color.toHex() ?? ""
        )
        
        albumStore.create(body: body)
    }
    
}
