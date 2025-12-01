//
//  VideoPlaybackRequestResult.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import AVKit
import Photos

public struct VideoPlaybackRequestResult {
    public var requestId: PHImageRequestID?
    public var playerItem: AVPlayerItem
    
    public init(
        requestId: PHImageRequestID? = nil,
        playerItem: AVPlayerItem
    ) {
        self.requestId = requestId
        self.playerItem = playerItem
    }
}
