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

public struct GalleryScreen: View {
    
    @Dependency(\.assetManager) private var assetManager
    @EnvironmentObject private var router: Router<AppDestination>
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        PhotoCollectionView(
            assets: assetManager.hasAlbumsDisplayed ? assetManager.allAssets : assetManager.assetsWithoutAlbums,
            itemSpacing: 2,
            onAssetSelected: {
                router.push(.asset(.assetDetail(asset: $0)))
            }
        )
        .scrollIndicators(.hidden)
        .background(Color.Background.bg50)
        .ignoresSafeArea(edges: .bottom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                @Bindable var assetManager = assetManager
                Picker("", selection: $assetManager.hasAlbumsDisplayed) {
                    Text("All pictures").tag(true)
                    Text("Without albums").tag(false)
                }
                .labelsHidden()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GalleryScreen()
}
