//
//  PixelyApp.swift
//  Pixely
//
//  Created by Theo Sementa on 01/11/2025.
//

import SwiftUI
import Persistence

@main
struct PixelyApp: App {
    let coreDataStack = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .environment(\.managedObjectContext, coreDataStack.viewContext)
        }
    }
}
