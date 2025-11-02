//
//  PixelyApp.swift
//  Pixely
//
//  Created by Theo Sementa on 01/11/2025.
//

import SwiftUI
import Persistence
import Stores
import Models

@main
struct PixelyApp: App {
    let coreDataStack = CoreDataStack.shared
    
    @State private var albumStore: AlbumStore = .shared
    @State private var assetDetailledStore: AssetDetailledStore = .shared

    var body: some Scene {
        WindowGroup {
            VStack {
                Button {
                    albumStore.fetchAll()
                } label: {
                    Text("Fetch albums")
                }
                
                Button {
                    albumStore.create(body: .create(name: "Test", emoji: "🤣", colorHex: "123456"))
                } label: {
                    Text("Create an album")
                }
                
                if let album = albumStore.albums.first {
                    Button {
                        assetDetailledStore.create(albumId: album.id)
                    } label: {
                        Text("Create asset")
                    }
                }

            }
            .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
