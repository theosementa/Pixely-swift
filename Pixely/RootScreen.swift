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
    
    @Dependency(\.assetManager) private var assetManager
    @Dependency(\.albumStore) private var albumStore
    @Dependency(\.assetDetailedStore) private var assetDetailedStore
        
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
            assetDetailedStore.fetchAll()
        }
    }
}

// MARK: - Preview
#Preview {
    RootScreen()
}
