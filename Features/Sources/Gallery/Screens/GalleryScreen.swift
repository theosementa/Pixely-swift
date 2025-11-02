//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import PhotoAsset

public struct GalleryScreen: View {
    
    @Environment(AssetManager.self) private var assetManager
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        PhotoCollectionView(
            assets: assetManager.photoAssetCollection.phAssets,
            itemSpacing: 2,
            onAssetSelected: { _ in }
        )
        .ignoresSafeArea(edges: .bottom)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - Preview
#Preview {
    GalleryScreen()
}
