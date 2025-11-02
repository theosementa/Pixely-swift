//
//  RootScreen.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation
import Stores

import Albums
import Gallery
import PhotoAsset

struct RootScreen: View {
        
    @State private var assetManager: AssetManager = .init()
        
    // MARK: - View
    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                TabbarIOS26View()
            } else {
                ClassicTabbarView()
            }
        }
        .environment(assetManager)
    }
}

// MARK: - Preview
#Preview {
    RootScreen()
}
