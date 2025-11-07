//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Stores
import Dependencies
import Navigation
import PhotoAsset

public struct AlbumDetailScreen: View {
    
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router<AppDestination>
        
    // MARK: Init
    public init(albumId: UUID) {
        self._viewModel = State(wrappedValue: .init(albumId: albumId))
    }
    
    // MARK: - View
    public var body: some View {
        VStack {
            if let album = viewModel.album {
                Text("Hello, World! \(viewModel.albumId)")
                
                if let subAlbums = album.subAlbums {
                    ForEach(subAlbums, id: \.self) { subAlbum in
                        NavigationButtonView(
                            route: .push,
                            destination: .album(.detail(albumId: subAlbum.id))
                        ) {
                            AlbumRowView(album: subAlbum)
                                .padding(8)
                        }
                    }
                }
                
                NavigationButtonView(
                    route: .push,
                    destination: .album(.createSubAlbum(parentAlbum: album))
                ) {
                    Text("Create subAlbum")
                }
                
                Button {
                    viewModel.albumStore.delete(id: viewModel.albumId)
                    dismiss()
                } label: {
                    Text("Delete")
                }
                
                PhotoCollectionView(
                    assets: viewModel.assets,
                    itemSpacing: 2,
                    onAssetSelected: {
                        router.push(.gallery(.assetDetail(asset: $0)))
                    }
                )
            }
        }
        .onAppear {
            if let album = viewModel.album {
                let subAlbums = viewModel.albumStore.fetchSubAlbums(for: album)
                viewModel.album?.subAlbums = subAlbums
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumDetailScreen(albumId: UUID())
}
