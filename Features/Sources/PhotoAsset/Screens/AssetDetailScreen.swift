//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import SwiftUI
import Photos
import Dependencies

public struct AssetDetailScreen: View {
        
    @State private var viewModel: ViewModel
    
    public init(asset: PHAsset) {
        self._viewModel = State(wrappedValue: .init(asset: asset))
    }
    
    // MARK: - View
    public var body: some View {
        VStack {
            if viewModel.asset.playbackStyle == .image {
                PhotoView(asset: viewModel.asset)
            } else {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
        .overlay(alignment: .topTrailing) {
            Picker("Album", selection: $viewModel.albumSelected) {
                ForEach(viewModel.albumStore.albums) { album in
                    Text(album.name).tag(album)
                }
            }
            .padding()
            .onChange(of: viewModel.albumSelected) { _, newValue in
                if newValue != .noAlbum {
                    if let assetEntity = viewModel.assetEntity {
                        viewModel.assetDetailedStore.updateAlbum(assetEntity, newAlbum: newValue)
                    } else {
                        if let detailedAsset = viewModel.detailedAsset, let body = detailedAsset.toBody(album: newValue) {
                            viewModel.assetDetailedStore.create(body)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadEntity()
            
            PHAssetHelper.detailed(for: viewModel.asset) { detailedAsset in
                self.viewModel.detailedAsset = detailedAsset
            }
        }
    }
    
}
