//
//  ClassicTabbarView.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation

import Gallery
import PhotoAsset
import Albums

struct ClassicTabbarView: View {
    
    // MARK: Routers
    @State private var appRouterManager: AppRouterManager = .shared
    @StateObject private var galleryRouter: Router<AppDestination> = .init()
    @StateObject private var albumsRouter: Router<AppDestination> = .init()
    
    // MARK: - View
    var body: some View {
        TabView(selection: $appRouterManager.selectedTab) {
            NavigationStackView(
                router: galleryRouter,
                destinationContent: { AppDestination.view(for: $0) },
                initialContent: { GalleryScreen() }
            )
            .tag(AppTabs.gallery)
            .tabItem {
                Label("Gallery", systemImage: "photo.on.rectangle.angled") // TODO: TBL
            }
            
            NavigationStackView(
                router: albumsRouter,
                destinationContent: { AppDestination.view(for: $0) },
                initialContent: { AlbumsListScreen() }
            )
            .tag(AppTabs.albums)
            .tabItem {
                Label("Albums", systemImage: "rectangle.stack.fill") // TODO: TBL
            }
        }
        .environment(appRouterManager)
    }
}

// MARK: - Preview
#Preview {
    ClassicTabbarView()
        .environment(AssetManager())
}
