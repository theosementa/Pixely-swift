//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import Models
import Repositories

@MainActor @Observable
public final class AssetDetailledStore {
    public static let shared = AssetDetailledStore()
    
    public var assets: [AssetDetailledStore] = []
}

public extension AssetDetailledStore {
    
    func create(albumId: UUID) {
        do {
            let asset = try AssetDetailledRepository.create(body: .init(albumId: albumId))
            print("🔥 ASSET : \(asset)")
        } catch {
            
        }
    }
    
}

