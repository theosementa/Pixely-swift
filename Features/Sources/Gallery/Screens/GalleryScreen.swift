//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import PhotoAsset
import Navigation

public struct GalleryScreen: View {
    
    @Environment(AssetManager.self) private var assetManager
    @EnvironmentObject private var router: Router<AppDestination>
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        PhotoCollectionView(
            assets: assetManager.photoAssetCollection.phAssets,
            itemSpacing: 2,
            onAssetSelected: {
                router.push(.asset(.assetDetail(asset: $0)))
            }
        )
        .scrollIndicators(.hidden)
        .background(Color.Background.bg50)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview
#Preview {
    GalleryScreen()
}
