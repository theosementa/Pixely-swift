//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Photos

// TODO: Sendable + delete type of info to replace with String or Int etc ...
public struct ContentEditWithInfoModel: @unchecked Sendable {
    public var content: PHContentEditingInput?
    public var info: [AnyHashable: Any]?
    
    public init(
        content: PHContentEditingInput? = nil,
        info: [AnyHashable: Any]? = nil
    ) {
        self.content = content
        self.info = info
    }
}
