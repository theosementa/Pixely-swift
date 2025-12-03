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
    
    @State private var viewModel: ViewModel = .init()
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        AssetsListView(
            assets: viewModel.hasAlbumsDisplayed ? assetManager.allAssets : assetManager.assetsWithoutAlbums,
            assetsSelected: $viewModel.currentAssetsSelected,
            isSelectModeEnabled: viewModel.isSelectModeEnabled
        )
        .scrollIndicators(.hidden)
        .background(Color.Background.bg50)
        .toolbar(viewModel.isSelectModeEnabled ? .hidden : .automatic, for: .tabBar)
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
            ToolbarItem(placement: .topBarLeading) { filterAssetsPickerView }
            ToolbarItem(placement: .topBarTrailing) { multiSelectionButtonView }
        }
    }
}

// MARK: - Subviews
extension GalleryScreen {
    
    @ViewBuilder
    var filterAssetsPickerView: some View {
        @Bindable var assetManager = assetManager
        Picker("", selection: $viewModel.hasAlbumsDisplayed) {
            Text("All pictures").tag(true)
            Text("Without albums").tag(false)
        }
        .labelsHidden()
    }
    
    var multiSelectionButtonView: some View {
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

// MARK: - Preview
#Preview {
    GalleryScreen()
}
