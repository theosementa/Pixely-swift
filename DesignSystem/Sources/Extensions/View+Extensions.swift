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
    
    public func roundedRectangleBorder(
        _ color: Color,
        radius: CGFloat,
        lineWidth: CGFloat? = nil,
        strokeColor: Color? = nil
    ) -> some View {
        return self
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(color)
                    .overlay {
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .stroke(strokeColor ?? Color.clear, lineWidth: lineWidth ?? 0)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
}
