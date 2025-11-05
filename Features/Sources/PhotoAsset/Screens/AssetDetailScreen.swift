//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import SwiftUI
import Photos

public struct AssetDetailScreen: View {
    
    let asset: PHAsset
    
    public init(asset: PHAsset) {
        self.asset = asset
    }
    
    // MARK: - View
    public var body: some View {
        if asset.playbackStyle == .image {
            PhotoView(asset: asset)
        } else {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
}
