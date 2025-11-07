//
//  ImageWithInfoModel.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI

// TODO: Sendable + delete type of info to replace with String or Int etc ...
public struct ImageWithInfoModel: @unchecked Sendable {
    public var image: UIImage?
    public var info: [AnyHashable: Any]?
    
    public init(
        image: UIImage? = nil,
        info: [AnyHashable: Any]? = nil
    ) {
        self.image = image
        self.info = info
    }
}
