//
//  BundleHelper.swift
//  DesignSystem
//
//  Created by Theo Sementa on 10/11/2025.
//

import Foundation

struct BundleHelper {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var bundle: Bundle {
        return isPreview ? Bundle.module : Bundle.main
    }
}

