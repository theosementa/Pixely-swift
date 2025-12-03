//
//  AssetGridCell.swift
//  Features
//
//  Created by Theo Sementa on 02/12/2025.
//

import SwiftUI
import Photos

struct AssetGridCellView: View {
    let asset: PHAsset
    let isSelected: Bool
    @State private var image: UIImage?
    
    private let imageManager = PHCachingImageManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
                
                if isSelected {
                    Color.white.opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 2)
                        )
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .padding(8)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
            .cornerRadius(8)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let targetSize = CGSize(width: 400, height: 400)
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            if let result = result {
                self.image = result
            }
        }
    }
}
