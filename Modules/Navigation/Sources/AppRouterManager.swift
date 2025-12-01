//
//  AppRouterManager.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import NavigationKit

@Observable
public final class AppRouterManager {
    @MainActor public static let shared = AppRouterManager()
    
    public var selectedTab: AppTabs = .gallery
    
    public var routers: [AppTabs: Router<AppDestination>] = [:]
}

public extension AppRouterManager {

    func register(router: Router<AppDestination>, for tab: AppTabs) {
        return routers[tab] = router
    }
    
    func router(for tab: AppTabs) -> Router<AppDestination>? {
        return routers[tab]
    }
    
    func resetRouters() {
        routers.removeAll()
    }
    
}
