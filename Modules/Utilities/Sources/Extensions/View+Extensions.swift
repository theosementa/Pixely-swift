//
//  File.swift
//  Extensions
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import SwiftUI

public extension View {
    
    func fullWidth(_ alignment: Alignment = .center) -> some View {
        return frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func fullSize(_ alignment: Alignment = .center) -> some View {
        return frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
}
