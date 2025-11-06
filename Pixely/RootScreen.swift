//
//  RootScreen.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation
import Stores
import Dependencies

import Albums
import Gallery
import PhotoAsset

struct RootScreen: View {
        
    @State private var assetManager: AssetManager = .init()
    
    @Dependency(\.albumStore) private var albumStore
        
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
        .onAppear {
            assetManager.askForAuthorization()
            albumStore.fetchAll()
        }
    }
}

// MARK: - Preview
#Preview {
    RootScreen()
}
