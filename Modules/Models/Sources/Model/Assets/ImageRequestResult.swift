//
//  ImageRequestResult.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Photos

public struct ImageRequestResult {
    public var requestId: PHImageRequestID?
    public var image: Image?
    public var isLowerQuality: Bool
    
    public init(
        requestId: PHImageRequestID? = nil,
        image: Image? = nil,
        isLowerQuality: Bool
    ) {
        self.requestId = requestId
        self.image = image
        self.isLowerQuality = isLowerQuality
    }
}
