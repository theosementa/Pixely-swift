//
//  File.swift
//  Extensions
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import SwiftUI

public extension Color {
    
    init(hex: String) {
        let cleanHex = hex
            .replacingOccurrences(of: "#", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17) & 0xFF, (int >> 4 * 17) & 0xFF, int * 17 & 0xFF)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            opacity: CGFloat(a) / 255
        )
    }
    
    /// Convert Color in hex string (#RRGGBB or #RRGGBBAA)
    func toHex(includeAlpha: Bool = false) -> String? {
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                          Int(r * 255),
                          Int(g * 255),
                          Int(b * 255),
                          Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X",
                          Int(r * 255),
                          Int(g * 255),
                          Int(b * 255))
        }
    }
    
}
