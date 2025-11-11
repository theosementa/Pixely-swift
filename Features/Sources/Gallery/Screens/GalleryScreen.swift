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
        .ignoresSafeArea(edges: .bottom)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - Preview
#Preview {
    GalleryScreen()
}
