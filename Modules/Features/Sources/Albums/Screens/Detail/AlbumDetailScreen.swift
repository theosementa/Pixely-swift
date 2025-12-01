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
import DesignSystem

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
        ScrollView {
            if let album = viewModel.album {
                if let subAlbums = album.subAlbums, !subAlbums.isEmpty {
                    LazyVGrid(
                        columns: [GridItem(spacing: Spacing.medium), GridItem(spacing: Spacing.medium)],
                        spacing: Spacing.standard
                    ) {
                        ForEach(subAlbums, id: \.self) { subAlbum in
                            NavigationButtonView(
                                route: .push,
                                destination: .album(.detail(albumId: subAlbum.id))
                            ) {
                                AlbumRowView(album: subAlbum)
                            }
                        }
                    }
                    .padding(Spacing.large)
                    .animation(.smooth, value: album.subAlbums?.count)
                }
                
                if !viewModel.assets.isEmpty {
                    PhotoCollectionViewWithFrame(
                        assets: viewModel.assets,
                        itemSpacing: 2,
                        onAssetSelected: {
                            router.push(.asset(.assetDetail(asset: $0)))
                        }
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .fullSize(.top)
        .navigationTitle(viewModel.navigationTitle)
        .background(Color.Background.bg50)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if let album = viewModel.album, album.isParentAlbum {
                        Button {
                            router.present(route: .sheet, .album(.createSubAlbum(parentAlbum: album))) {
                                viewModel.fetchAlbumWithSubAlbums()
                            }
                        } label: {
                            Label("Add a subalbum", systemImage: "plus")
                        }
                    }

                    Button(role: .destructive) {
                        viewModel.albumStore.delete(id: viewModel.albumId)
                        dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .onAppear {
            viewModel.fetchAlbumWithSubAlbums()
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumDetailScreen(albumId: UUID())
}
