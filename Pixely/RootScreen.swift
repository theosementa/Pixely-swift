//
//  RootScreen.swift
//  Pixely
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Navigation

import Albums

struct RootScreen: View {
    
    @State private var appRouterManager: AppRouterManager = .shared
    @StateObject private var galleryRouter: Router<AppDestination> = .init()
    
    // MARK: - View
    var body: some View {
        TabView(selection: $appRouterManager.selectedTab) {
            NavigationStackView(
                router: galleryRouter,
                destinationContent: { AppDestination.view(for: $0) },
                initialContent: { AlbumsListScreen() }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    RootScreen()
}
