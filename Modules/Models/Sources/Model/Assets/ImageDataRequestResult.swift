//
//  ImageDataRequestResult.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos
import UIKit

public struct ImageDataRequestResult {
    public var requestId: PHImageRequestID?
    public var uiImage: UIImage?
    public var imageData: Data
    public var dataUTI: String?

    public init(
        requestId: PHImageRequestID?,
        dataUTI: String?,
        imageData: Data
    ) {
        self.imageData = imageData
        self.dataUTI = dataUTI
        self.uiImage = UIImage(data: imageData)
    }
}
