//
//  TabbarIOS26View.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation

import Gallery
import PhotoAsset
import Albums

@available(iOS 26.0, *)
struct TabbarIOS26View: View {
        
    // MARK: Routers
    @State private var appRouterManager: AppRouterManager = .shared
    @StateObject private var galleryRouter: Router<AppDestination> = .init()
    @StateObject private var albumsRouter: Router<AppDestination> = .init()
    
    // MARK: - View
    var body: some View {
        TabView(selection: $appRouterManager.selectedTab) {
            Tab("Gallery", systemImage: "photo.on.rectangle.angled", value: AppTabs.gallery) { // TODO: TBL
                NavigationStackView(
                    router: galleryRouter,
                    destinationContent: { AppDestination.view(for: $0) },
                    initialContent: { GalleryScreen() }
                )
            }

            Tab("Albums", systemImage: "rectangle.stack.fill", value: AppTabs.albums) { // TODO: TBL
                NavigationStackView(
                    router: albumsRouter,
                    destinationContent: { AppDestination.view(for: $0) },
                    initialContent: { AlbumsListScreen() }
                )
            }
        }
        .environment(appRouterManager)
    }
}

// MARK: - Preview
@available(iOS 26.0, *)
#Preview {
    TabbarIOS26View()
        .environment(AssetManager())
}
