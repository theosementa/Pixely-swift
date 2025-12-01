//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import SwiftUI
import Photos
import Dependencies
import Models
import DesignSystem
import Navigation

public struct AssetDetailScreen: View {
        
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router<AppDestination>
        
    // MARK: Init
    public init(asset: PHAsset) {
        self._viewModel = State(wrappedValue: .init(asset: asset))
    }
    
    // MARK: - View
    public var body: some View {
        VStack {
            switch viewModel.asset.playbackStyle {
            case .image:
                PhotoView(asset: viewModel.asset)
            case .video, .videoLooping:
                VideoView(asset: viewModel.asset)
            default:
                EmptyView()
            }
        }
        .fullSize()
        .background(Color.Background.bg50)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker(selection: $viewModel.albumSelectedId) {
                    Section {
                        ForEach(viewModel.parentAlbumsSelectable) { album in
                            Text(album.name).tag(album.id)
                        }
                    } header: {
                        Text("Albums")
                    }

                    Section {
                        ForEach(viewModel.subAlbumsSelectable) { subAlbum in
                            Text(subAlbum.name).tag(subAlbum.id)
                        }
                    } header: {
                        Text("Subalbums")
                    }
                } label: {
                    HStack(spacing: Spacing.small) {
                        Image(systemName: "chevron.up.chevron.down")
                        Text(viewModel.albumSelected?.name ?? "")
                    }
                }
                .labelsHidden()
                .onChange(of: viewModel.albumSelectedId) { _, newValue in
                    viewModel.onSelectNewAlbum(newValue)
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button("", systemImage: viewModel.asset.isFavorite ? "heart.fill" : "heart") {
                    viewModel.setIsFavorite()
                }
                .labelsHidden()
                
                Spacer()
                
                Button("", systemImage: "info.circle") {
                    router.present(route: .modalFitContent, .asset(.assetInfo(asset: viewModel.detailedAsset)))
                }
                .labelsHidden()
                
                Spacer()
                
                Button("", systemImage: "trash", role: .destructive) {
                    viewModel.deleteAsset(dismiss: dismiss)
                }
                .labelsHidden()
            }
        }
        .onAppear {
            viewModel.loadEntity()
            
            if self.viewModel.detailedAsset == nil {
                PHAssetHelper.detailed(for: viewModel.asset) { detailedAsset in
                    self.viewModel.detailedAsset = detailedAsset
                }
            }
        }
    }
    
}
