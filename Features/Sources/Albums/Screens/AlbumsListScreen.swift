//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Stores
import Navigation
import Dependencies

public struct AlbumsListScreen: View {
    
    @Dependency(\.albumStore) private var albumStore
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        VStack(spacing: 16) {
            NavigationButtonView(
                route: .push,
                destination: .album(.create)
            ) {
                Text("Create album")
            }
            
            List(albumStore.parentAlbums) { album in
                NavigationButtonView(
                    route: .push,
                    destination: .album(.detail(albumId: album.id))
                ) {
                    AlbumRowView(album: album)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumsListScreen()
}
