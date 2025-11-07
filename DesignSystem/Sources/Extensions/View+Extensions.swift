//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 07/11/2025.
//

import Foundation
import SwiftUI

// MARK: - View Extension
extension View {
    
    public func customFont(_ font: ExtendedUIFont) -> some View {
        var uiFont: UIFont {
            return UIFont(name: font.name, size: font.size) ?? UIFont.systemFont(ofSize: font.size)
        }
        
        return self
            .font(Font(uiFont))
            .lineSpacing(font.lineHeight - uiFont.lineHeight)
            .padding(.vertical, (font.lineHeight - uiFont.lineHeight) / 2)
    }
    
}
