//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation

extension CGSize {
    
    public func multiplying(by scalar: CGFloat) -> CGSize {
        return CGSize(width: width * scalar, height: height * scalar)
    }
    
}
