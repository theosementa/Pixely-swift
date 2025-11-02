//
//  RootScreen.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation

import Albums
import Gallery
import PhotoAsset

struct RootScreen: View {
    
    @State private var appRouterManager: AppRouterManager = .shared
    @StateObject private var galleryRouter: Router<AppDestination> = .init()
    
    @State private var assetManager: AssetManager = .init()
    
    // MARK: - View
    var body: some View {
        TabView(selection: $appRouterManager.selectedTab) {
            NavigationStackView(
                router: galleryRouter,
                destinationContent: { AppDestination.view(for: $0) },
                initialContent: { GalleryScreen() }
            )
        }
        .environment(assetManager)
    }
}

// MARK: - Preview
#Preview {
    RootScreen()
}
