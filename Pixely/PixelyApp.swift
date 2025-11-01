//
//  PixelyApp.swift
//  Pixely
//
//  Created by Theo Sementa on 01/11/2025.
//

import SwiftUI
import CoreData

@main
struct PixelyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
