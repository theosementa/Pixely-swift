//
//  ImageDataWithInfoModel.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI

// TODO: Sendable + delete type of info to replace with String or Int etc ...
public struct ImageDataWithInfoModel: @unchecked Sendable {
    public var data: Data?
    public var dataUTI: String?
    public var orientation: CGImagePropertyOrientation
    public var info: [AnyHashable: Any]?
    
    public init(
        data: Data? = nil,
        dataUTI: String? = nil,
        orientation: CGImagePropertyOrientation,
        info: [AnyHashable: Any]? = nil
    ) {
        self.data = data
        self.dataUTI = dataUTI
        self.orientation = orientation
        self.info = info
    }
}
