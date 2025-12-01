//
//  VideoView.swift
//  Features
//
//  Created by Theo Sementa on 07/11/2025.
//

import SwiftUI
import AVKit
import Photos

struct VideoView: View {
    
    // MARK: Dependencies
    var asset: PHAsset
    
    // MARK: Environment
    @Environment(AssetManager.self) private var assetManager

    // MARK: State
    @State private var player: AVPlayer = AVPlayer()
    @State private var playerItem: AVPlayerItem?
    
    // MARK: - View
    var body: some View {
        Group {
            if playerItem != nil {
                VideoPlayer(player: player)
            } else {
                ProgressView()
            }
        }
        .task {
            guard playerItem == nil else { return }
            do {
                let result = try await assetManager.cacheManager.requestVideoPlayback(for: asset)
                playerItem = result.playerItem
                player.replaceCurrentItem(with: result.playerItem)
                player.play()
            } catch {
                print(error)
            }
        }
        .onDisappear {
            self.player.pause()
            self.player = AVPlayer()
            self.playerItem = nil
        }
    }
}
