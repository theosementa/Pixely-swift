//
//  PhotoView.swift
//  Features
//
//  Created by Theo Sementa on 05/11/2025.
//

import SwiftUI
import Photos

public struct PhotoView: View {
    
    // MARK: Dependencies
    var asset: PHAsset
    
    // MARK: Environment
    @Environment(AssetManager.self) private var assetManager
    
    // MARK: State
    @State private var uiImage: UIImage?
    @State private var tapLocation: CGPoint = .zero
    @State var saveData: () async -> Void = { }
    
    public init(
        asset: PHAsset
    ) {
        self.asset = asset
    }
    
    // MARK: - View
    public var body: some View {
        Group {
            if let uiImage {
                InteractiveImageView(
                    image: uiImage,
                    zoomInteraction: .init(
                        location: tapLocation,
                        scale: 1,
                        animated: true
                    )
                )
                .onTapGesture(count: 2) { gesture in
                    tapLocation = gesture
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                let result = try await assetManager.cacheManager.requestImageData(for: asset)
                guard let uiImage = result.uiImage else { return }
                self.uiImage = uiImage
                saveData = {
                    do {
                        try await assetManager.createAsset(data: result.imageData, type: .photo)
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
        .onDisappear {
            self.uiImage = nil
            self.saveData = { }
        }
    }
}
