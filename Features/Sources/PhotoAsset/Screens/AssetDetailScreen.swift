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

public struct AssetDetailScreen: View {
        
    @State private var viewModel: ViewModel
    
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
            
            Text(viewModel.detailedAsset?.album?.name ?? "no")
            Text(viewModel.detailedAsset?.software ?? "no")
            Text(viewModel.detailedAsset?.playbackStyle.rawValue.formatted() ?? "no")
        }
        .overlay(alignment: .topTrailing) {
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
                Text(viewModel.albumSelected?.name ?? "")
            }
            .padding()
            .onChange(of: viewModel.albumSelectedId) { _, newValue in
                viewModel.onSelectNewAlbum(newValue)
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
