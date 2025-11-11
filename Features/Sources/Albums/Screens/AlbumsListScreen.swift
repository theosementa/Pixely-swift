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
import DesignSystem

public struct AlbumsListScreen: View {
    
    @Dependency(\.albumStore) private var albumStore
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(spacing: Spacing.medium), GridItem(spacing: Spacing.medium)],
                spacing: Spacing.standard
            ) {
                ForEach(albumStore.parentAlbums) { album in
                    NavigationButtonView(
                        route: .push,
                        destination: .album(.detail(albumId: album.id))
                    ) {
                        AlbumRowView(album: album)
                    }
                }
            }
            .padding(Spacing.large)
        }
        .scrollIndicators(.hidden)
        .fullSize(.top)
        .background(Color.Background.bg50)
        .navigationTitle("Albums")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") { router.present(route: .sheet, .album(.create)) }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumsListScreen()
}
