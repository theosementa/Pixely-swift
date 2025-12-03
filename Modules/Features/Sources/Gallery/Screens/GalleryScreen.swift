//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import PhotoAsset
import Navigation
import Dependencies
import DesignSystem

public struct GalleryScreen: View {
    
    @Dependency(\.assetManager) private var assetManager
    @EnvironmentObject private var router: Router<AppDestination>
    
    @State private var viewModel: ViewModel = .init()
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        AssetsListView(
            assets: assetManager.hasAlbumsDisplayed ? assetManager.allAssets : assetManager.assetsWithoutAlbums,
            assetsSelected: $viewModel.currentAssetsSelected,
            isSelectModeEnabled: viewModel.isSelectModeEnabled
        )
        .scrollIndicators(.hidden)
        .background(Color.Background.bg50)
        .toolbar(viewModel.isSelectModeEnabled ? .hidden : .visible, for: .tabBar)
        .overlay(alignment: .bottom) {
            if viewModel.isSelectModeEnabled {
                MultiSelectionView(
                    currentAlbumIdSelected: $viewModel.currentAlbumIdSelected,
                    currentAssetsSelected: $viewModel.currentAssetsSelected
                )
                .padding(4)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                @Bindable var assetManager = assetManager
                Picker("", selection: $assetManager.hasAlbumsDisplayed) {
                    Text("All pictures").tag(true)
                    Text("Without albums").tag(false)
                }
                .labelsHidden()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isSelectModeEnabled.toggle()
                } label: {
                    if viewModel.isSelectModeEnabled {
                        Image(systemName: "xmark")
                    } else {
                        Text("Select")
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GalleryScreen()
}
