//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import AVFoundation

// TODO: Sendable + delete type of info to replace with String or Int etc ...
public struct VideoWithInfoModel: @unchecked Sendable {
    public var player: AVPlayerItem?
    public var info: [AnyHashable: Any]?
    
    public init(
        player: AVPlayerItem? = nil,
        info: [AnyHashable: Any]? = nil
    ) {
        self.player = player
        self.info = info
    }
}
