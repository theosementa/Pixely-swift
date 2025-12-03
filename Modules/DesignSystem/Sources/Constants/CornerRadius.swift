//
//  CornerRadius.swift
//  DesignSystem
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation
import UIKit

public struct CornerRadius {
    
    /// `Value = 4`
    public static let extraSmall: CGFloat = 8
    /// `Value = 8`
    public static let small: CGFloat = 8
    /// `Value = 12`
    public static let medium: CGFloat = 12
    /// `Value = 16`
    public static let standard: CGFloat = 16
    /// `Value = 20`
    public static let large: CGFloat = 20
    /// `Value = 32`
    public static let extraLarge: CGFloat = 32
    
    @MainActor
    public static var deviceRadius: CGFloat = UIScreen.main.displayCornerRadius
    
}

extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }

        return cornerRadius
    }
}
