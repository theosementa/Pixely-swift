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

    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
